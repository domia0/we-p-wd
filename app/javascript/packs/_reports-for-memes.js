export function reportsForMemes() {
  // clear and add info to modal window
  $('.open-report-window-meme-btn').click(function() {
    $('#reportMemeModal form')
      .attr('action', 'en/memes/' + $(this).attr('meme_id') + '/reports')
      .attr('meme_id', $(this).attr('meme_id'))
  });

  // send report
  $('.send-report-meme-btn').click(function (event) {
    let data = {
      report: {
        reason: $('.report-for-meme-form input[name="report[reason]"]:checked').val(),
      },
      meme_id: $('#reportMemeModal form').attr('meme_id'),
      authenticity_token: $('.report-for-meme-form > input').first().val()
    };
    $.ajax({
      type: 'POST',
      url: $('#reportMemeModal form').attr('action'),
      data: data,
      dataType: 'json',
      encode: true,
    }).done(function () {
      $('.send-report-meme-btn').attr('disabled', false);
      $('#reportMemeModal').modal('toggle');
    }).fail(function (jqXHR) {
      $('.send-report-meme-btn')
        .attr('disabled', true)
        .removeClass('btn-primary')
        .addClass('btn-secondary')
        .text('First of all you must be login')
    });
    event.preventDefault();
  });
}