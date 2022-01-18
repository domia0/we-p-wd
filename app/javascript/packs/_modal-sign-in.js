export function modalSignIn() {
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
    }).done(function () {
      location.reload();
    }).fail(function (jqXHR) {
        $('.sign-in-error').css('display', 'block');
        $('.sign-in-form > .btn').attr('disabled', false)
      });
    event.preventDefault();
  });
}