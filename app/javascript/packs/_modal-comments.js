export function modalComments() {
  //load all comments by meme_id + add func to add or remove like
  function loadComments(memeId) {
    $.ajax({
      type: 'GET',
      url: '/all-comments-for-meme/' + memeId,
    }).done(function(comments) {
      if (comments.length === 0) {
        $('.no-comments').removeClass('d-none')
      } else {
        $('.no-comments').addClass('d-none')
      }
      comments.forEach(function(item){
        let headerDiv  = $('<div>',  {class: 'comment bg-light-blue m-2 rounded'});
        // Comment's Header
        let headerCol  = $('<div>',  {class: 'col-12 d-flex justify-content-between align-items-center mt-1 pt-1 px-3'});
        let headerUser = $('<a>',    {href: '?user=' + item.userName, text: item.userName});
        let headerDate = $('<span>', {class: 'comment-date', text: item.date});

        // Report dropdown for comment
        let reportDrdw        = $('<div>', {class: 'dropdown comment-more'});
        let reportDrdwBtn     = $('<button>', {class: 'more-btn', type: 'button', id: 'dropdownMenuButton2', 'aria-expanded': 'false', 'data-bs-toggle': 'dropdown'});
        let reportDrdwBtnText = $('<i>', {class: 'bi bi-exclamation-diamond fs-2 ms-2 text-warning'});
        let reportDrdwUl = $('<ul>', {class: 'dropdown-menu', 'aria-labelledby': 'dropdownMenuButton2'});
        let reportDrdwLi = $('<li>');
        let reportDrdwA1 = $('<a>', {href: '#', meme_id: item.meme_id, comment_id: item.id, class: 'dropdown-item send-report-comment-btn', text: 'Racism'});
        let reportDrdwA2 = $('<a>', {href: '#', meme_id: item.meme_id, comment_id: item.id, class: 'dropdown-item send-report-comment-btn', text: 'Violence'});
        let reportDrdwA3 = $('<a>', {href: '#', meme_id: item.meme_id, comment_id: item.id, class: 'dropdown-item send-report-comment-btn', text: 'Pornography'});
        let reportDrdwA4 = $('<a>', {href: '#', meme_id: item.meme_id, comment_id: item.id, class: 'dropdown-item send-report-comment-btn', text: 'Religion'});
        let reportDrdwA5 = $('<a>', {href: '#', meme_id: item.meme_id, comment_id: item.id, class: 'dropdown-item send-report-comment-btn', text: 'Discrimination'});

        // Comment's Body
        let bodyCol  =    $('<div>',  {class: 'col-12 d-flex justify-content-start mb-1 pb-2 px-3'});
        let bodyText =    $('<div>',  {class: 'col-10 position-relative', text: item.comment});
        let bodyLike =    $('<div>',  {class: 'col-2 d-flex justify-content-between align-items-start ps-4 pe-3'});
        let bodyLikeBtn = $('<div>');
        let bodyLikeCnt = $('<div>',  {class: 'mt-2', text: item.likes});

        if (item.liked) {
          bodyLikeBtn = $('<i>',
            {
              class: 'bi bi-hand-thumbs-up-fill color-light-blue fs-3 add-remove-like-comment',
              meme_id: item.meme_id,
              comment_id: item.id,
              like_id: item.like_id,
              checked: true
            });
        } else {
          bodyLikeBtn = $('<i>',
            {
              class: 'bi bi-hand-thumbs-up fs-3 add-remove-like-comment',
              meme_id: item.meme_id,
              comment_id: item.id
            });
        }
        // Create an element complete
        headerDiv
          .append(headerCol
            .append(headerUser)
            .append(headerDate)
            .append(reportDrdw
              .append(reportDrdwBtn
                .append(reportDrdwBtnText))
              .append(reportDrdwUl
                .append(reportDrdwLi
                  .append(reportDrdwA1))
                .append(reportDrdwLi
                  .append(reportDrdwA2))
                .append(reportDrdwLi
                  .append(reportDrdwA3))
                .append(reportDrdwLi
                  .append(reportDrdwA4))
                .append(reportDrdwLi
                  .append(reportDrdwA5))))
          ).append(bodyCol
          .append(bodyText)
          .append(bodyLike
            .append(bodyLikeBtn)
            .append(bodyLikeCnt))
        );
        // Add element to parent
        $('.all-comments-modal').append(headerDiv)
      });

      // send report for comment
      $('.send-report-comment-btn').click(function (event) {
        event.preventDefault();
        let data = {
          report: {
            reason: $(this).text().toLowerCase(),
          },
          comment_id: $(this).attr('comment_id'),
        };
        $.ajax({
          type: 'POST',
          beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
          },
          url: '/en/memes/' + $(this).attr('meme_id') + '/comments/' + $(this).attr('comment_id') + '/reports',
          data: data,
          dataType: 'json',
          encode: true,
        }).done(function () {
          // pa-pa-ram
        }).fail(function () {
          $('#commentsModal').modal('toggle');
          $('#loginModal').modal('toggle');
        });
      });

      // Add or remove like for comment
      $('.add-remove-like-comment').click(function() {
        // Wenn ein User sich noch nicht eingeloggt hat
        if ( $('.user-signed-in').length === 0 ) {
          $('#commentsModal').modal('toggle');
          $('#loginModal').modal('toggle');
          return;
        }
        // Ganz normales Verhalten
        let like = $(this);
        // remove like from comment
        if ($(this).attr('checked')) {
          $.ajax({
            type: 'DELETE',
            url: '/en/memes/' + $(this).attr('meme_id') + '/comments/' + $(this).attr('comment_id') + '/likes/' + $(this).attr('like_id'),
            beforeSend: function(xhr) {
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            dataType: 'json',
            encode: true,
          }).done(function () {
            like.removeClass('bi-hand-thumbs-up-fill color-light-blue').addClass('bi-hand-thumbs-up');
            like.removeAttr('like_id');
            like.attr('checked', false);
            like.next().text(+like.next().text() - 1)
          }).fail(function () {
            console.log('Error, remove like')
          })
        // add like to comment
        } else {
          $.ajax({
            type: 'POST',
            url: '/en/memes/' + $(this).attr('meme_id') + '/comments/' + $(this).attr('comment_id') + '/likes',
            beforeSend: function(xhr) {
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            dataType: 'json',
            encode: true,
          }).done(function (data) {
            like.removeClass('bi-hand-thumbs-up').addClass('bi-hand-thumbs-up-fill color-light-blue');
            like.attr('like_id', data.id);
            like.attr('checked', true);
            like.next().text(+like.next().text() + 1)
          }).fail(function () {
            console.log('Error: add like to comment')
          })
        }
      });
    }).fail(function () {
      console.log('Error: can not load comments')
    })
  }

  // show modal window with comments
  $('.all-comments').click(function() {
    // cleaning
    $('.all-comments-modal').empty();
    $('#commentBody').val('');
    // Wenn ein User sich noch nicht eingeloggt hat
    if ( $('.user-signed-in').length === 0 ) {
      $('.post-comment > .btn').attr('disabled', true);
      $('#commentBody').attr('placeholder', 'Log in to write a comment')
    }
    // set meme_id or whatever here...
    $('#commentsModal form').attr('meme_id', $(this).attr('meme_id'));
    // load new comments
    loadComments($(this).attr('meme_id'));
  });

  // Modal post comment
  $('.post-comment').submit(function(event) {
    let memeId = $(this).attr('meme_id');
    let comment = {
      comment: {
        body: $('#commentBody').val()
      }
    };
    $.ajax({
      type: 'POST',
      url: 'en/memes/' + $(this).attr('meme_id') + '/comments',
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      data: comment,
      dataType: 'json',
      encode: true,
    }).done(function () {
      // cleaning
      $('.all-comments-modal').empty();
      $('#commentBody').val('');
      $('.post-comment > .btn').attr('disabled', false);
      // load comments with a new one
      loadComments($('#commentsModal form').attr('meme_id'));
      // add +1 to the comments count
      $('.comments-count[meme_id=' + memeId + ']').each(function() {
        $(this).text(parseInt($(this).text()) + 1)
      })
    }).fail(function () {
      console.log('Error by adding comment')
    });
    event.preventDefault();
  });
}