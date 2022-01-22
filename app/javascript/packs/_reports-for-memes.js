export function reportsForMemes() {
  // clear and add info to modal window
  $('.open-report-window-meme-btn').click(function() {
    $('#reportMemeModal form')
      .attr('action', 'en/memes/' + $(this).attr('meme_id') + '/reports')
      .attr('meme_id', $(this).attr('meme_id'));
    $('.send-report-meme-btn')
      .attr('disabled', false)
      .removeClass('btn-danger')
      .removeClass('btn-success')
      .addClass('btn-primary');
    if ($('.lang').attr('current-lang') === 'de') {
      $('.send-report-meme-btn').text('Report senden');
    } else {
      $('.send-report-meme-btn').text('Send report');
    }

  });

  // send report
  $('.send-report-meme-btn').click(function (event) {
    event.preventDefault();
    let data = {
      report: {
        reason: $('.report-for-meme-form input[name="report[reason]"]:checked').val(),
      },
      meme_id: $('#reportMemeModal form').attr('meme_id'),
    };
    $.ajax({
      type: 'POST',
      url: $('#reportMemeModal form').attr('action'),
      data: data,
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'json',
      encode: true,
    }).done(function () {
      $('.send-report-meme-btn')
        .attr('disabled', true)
        .removeClass('btn-primary')
        .addClass('btn-success')
        .text('Success');
      // $('.send-report-meme-btn').attr('disabled', false);
      // $('#reportMemeModal').modal('toggle')
    }).fail(function (jqXHR) {
      $('.send-report-meme-btn')
        .attr('disabled', true)
        .removeClass('btn-primary')
        .addClass('btn-danger')
        .text('First of all you must be login');
    });

  });
}