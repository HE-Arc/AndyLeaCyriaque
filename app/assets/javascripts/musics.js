/**
 * Musics pages handlers
 */
var Musics = new function() {

    // musics/new
    this.new = function() {
        $('#new_music').submit(function(event) {
            // Stop form from submitting normally
            event.preventDefault();

            $.ajax({
                url: $(this).attr('action'),
                type: 'POST',
                data: new FormData(this),
                dataType: 'json',
                processData: false,
                contentType: false,
            }).done(function(data) {
                console.log(data.status);
                if (data.status == 'created') {
                    $.ajax({
                        url: "/music/" + data.message.id,
                    }).done(function(data) {
                        $('#ma-player-content').html(data);
                    });
                } else {
                    $('#error_explanation').removeClass('hidden');
                    $('#error_explanation_list').empty();
                    $.each(data.message, function(index, value) {
                        $('#error_explanation_list').append('<li>' + value + '</li>');
                    });
                }
            });
        });
    }
}
