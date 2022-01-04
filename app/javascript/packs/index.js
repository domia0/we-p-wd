$(document).ready(function () {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Modal Sign-in form
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  $('.sign-in-form').submit(function (event) {
    let formData = {
      user: {
        email: $('#signInEmail').val(),
        password: $('#signInPassword').val(),
      },
      authenticity_token: $('.sign-in-form > input').first().val()
    };
    $.ajax({
      type: 'POST',
      url: $('.sign-in-form').attr('action'),
      data: formData,
      dataType: 'json',
      encode: true,
    }).done(function () { location.reload(); })
      .fail(function (jqXHR) {
        $('.sign-in-error').css('display', 'block');
        $('.sign-in-form > .btn').attr('disabled', false)
      });
    event.preventDefault();
  });


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Modal Sign-up form
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  $('.sign-up-form').submit(function (event) {
    let formData = {
      user: {
        username:              $('#signupName').val(),
        email:                 $('#signupEmail').val(),
        password:              $('#signupPassword').val(),
        password_confirmation: $('#signupConfirmPassword').val(),
      },
      authenticity_token: $('.sign-up-form > input').first().val()
    };
    $.ajax({
      type: 'POST',
      url: $('.sign-up-form').attr('action'),
      data: formData,
      dataType: 'json',
      encode: true,
    }).done(function (data) {
      if (data.status === 'error') {
        if (data.message === 'email') {
          $('.sign-up-error-email').css('display', 'block');
          $('.sign-up-error-name').css('display', 'none');
        } else {
          $('.sign-up-error-name').css('display', 'block');
          $('.sign-up-error-email').css('display', 'none');
        }
        $('.sign-up-form > .btn').attr('disabled', false)
      } else {
        location.reload();
      }
    })
    event.preventDefault();
  });


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Add or remove like
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  $('.meme-like-add-remove').click(function() {
    // Wenn etwas schief gegangen ist
    if (!$(this).attr('meme_id')) return;
    // Wenn ein User sich noch nicht eingeloggt hat
    if ( $('.user-signed-in').length === 0 ) {
      $('#loginModal').modal('toggle'); return;
    }
    // Ganz normales Verhalten
    let like = $(this);
    // remove like
    if ($(this).attr('checked')) {
      $.ajax({
        type: 'DELETE',
        url: '/en/memes/' + $(this).attr('meme_id') + '/likes/' + $(this).attr('like_id'),
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
        dataType: 'json',
        encode: true,
      }).done(function () {
        like.removeClass('bi-heart-fill color-light-blue').addClass('bi-heart');
        like.attr('checked', false);
        like.prev().text(+like.prev().text() - 1);
      }).fail(function () {
        console.log('Error, remove like')
      })
    // add like
    } else {
      $.ajax({
        type: 'POST',
        url: '/en/memes/' + $(this).attr('meme_id') + '/likes',
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
        dataType: 'json',
        encode: true,
      }).done(function () {
        like.removeClass('bi-heart').addClass('bi-heart-fill color-light-blue');
        like.attr('checked', true);
        like.prev().text(+like.prev().text() + 1);
      }).fail(function () {
        console.log('Error, add like')
      })
    }
  });


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Modal comments
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //load all comments by meme_id + add func to add or remove like
  function loadComments(memeId) {
    $.ajax({
      type: 'GET',
      url: '/all-comments-for-meme/' + memeId,
    }).done(function (comments) {
      console.log(comments)
      if (comments.length === 0) {
        $('.no-comments').removeClass('d-none')
      } else {
        $('.no-comments').addClass('d-none')
      }
      comments.forEach(function(item){
        let commentHeaderDiv =   $('<div>',  {class: 'comment bg-light-blue m-2 rounded'});
        // Comment's Header
        let commentHeaderCol =   $('<div>',  {class: 'col-12 d-flex justify-content-between mt-1 pt-3 px-3'});
        let commentHeaderUser =  $('<a>',    {href: '#', text: item.userName});
        let commentHeaderDate =  $('<span>', {class: 'comment-date', text: item.date});
        // Comment's Body
        let commentBodyCol  =    $('<div>',  {class: 'col-12 d-flex justify-content-start mb-1 pb-2 px-3'});
        let commentBodyText =    $('<div>',  {class: 'col-10', text: item.comment});
        let commentBodyLike =    $('<div>',  {class: 'col-2 d-flex justify-content-end'});
        let commentBodyLikeBtn = $('<div>');
        if (item.liked) {
          commentBodyLikeBtn = $('<i>',
            {
              class: 'bi bi-hand-thumbs-up-fill color-light-blue fs-3 add-remove-like-comment',
              meme_id: item.meme_id,
              comment_id: item.id
            });
        } else {
          commentBodyLikeBtn = $('<i>',
            {
              class: 'bi bi-hand-thumbs-up fs-3 add-remove-like-comment',
              meme_id: item.meme_id,
              comment_id: item.id
            });
        }

        // Create an element complete
        commentHeaderDiv
          .append(commentHeaderCol
            .append(commentHeaderUser)
            .append(commentHeaderDate)
          ).append(commentBodyCol
          .append(commentBodyText)
          .append(commentBodyLike
            .append(commentBodyLikeBtn))
          );
        // Add element to parent :)
        $('.all-comments-modal').append(commentHeaderDiv)
      });

      // Add or remove like for comment
      $('.add-remove-like-comment').click(function() {
        // // Wenn ein User sich noch nicht eingeloggt hat
        // if ( $('.user-signed-in').length === 0 ) {
        //   $('#loginModal').modal('toggle'); return;
        // }
        // Ganz normales Verhalten
        let like = $(this);
        // remove like
        console.log($(this));
        if ($(this).attr('checked')) {
          // $.ajax({
          //   type: 'DELETE',
          //   url: '/en/memes/' + $(this).attr('meme_id') + '/likes/' + $(this).attr('like_id'),
          //   beforeSend: function(xhr) {
          //     xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
          //   },
          //   dataType: 'json',
          //   encode: true,
          // }).done(function () {
          //   like.removeClass('bi-heart-fill color-light-blue').addClass('bi-heart');
          //   like.attr('checked', false);
          //   like.prev().text(+like.prev().text() - 1);
          // }).fail(function () {
          //   console.log('Error, remove like')
          // })
        // add like
        } else {
          $.ajax({
            type: 'POST',
            url: '/en/memes/' + $(this).attr('meme_id') + '/comments/' + $(this).attr('comment_id') + '/likes',
            beforeSend: function(xhr) {
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            dataType: 'json',
            encode: true,
          }).done(function () {
            like.removeClass('bi-hand-thumbs-up').addClass('bi-hand-thumbs-up-fill color-light-blue');
            like.attr('checked', true);
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
      console.log('Success')
      // cleaning
      $('.all-comments-modal').empty();
      $('#commentBody').val('');
      $('.post-comment > .btn').attr('disabled', false);
      // load comments with a new one
      loadComments($('#commentsModal form').attr('meme_id'));
      //
      $('.comments-count[meme_id=' + memeId + ']')
    }).fail(function () {
      console.log('Error')
    });
    event.preventDefault();
  });
});