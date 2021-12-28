$(document).ready(function () {

  // Sign-in form
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

  // Sign-up form
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

  // Add or remove like
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
});