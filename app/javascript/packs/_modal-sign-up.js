export function modalSignUp() {
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
          $('.sign-up-error-name' ).css('display', 'none');
        } else {
          $('.sign-up-error-name' ).css('display', 'block');
          $('.sign-up-error-email').css('display', 'none');
        }
        $('.sign-up-form > .btn').attr('disabled', false)
      } else {
        location.reload();
      }
    })
    event.preventDefault();
  });
}