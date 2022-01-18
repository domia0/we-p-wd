export function likesForMemes() {
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
        console.log('Error: remove like (meme)')
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
        console.log('Error: add like (meme)')
      })
    }
  });
}