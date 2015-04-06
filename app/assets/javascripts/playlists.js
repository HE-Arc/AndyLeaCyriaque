/**
 * Musics pages handlers
 */
var Playlists = new function() {

    this.new = function() {
        Player.show("playlists/new", function() {
            $('#new_playlist').submit(function(event) {
                // Stop form from submitting normally
                event.preventDefault();

                // Handle data submission
                $.ajax({
                    url: $(this).attr('action'),
                    type: 'POST',
                    data: new FormData(this),
                    dataType: 'json',
                    processData: false,
                    contentType: false,
                }).done(function(data) {
                    if (data.status == 'created') {
                        Player.show('playlists/' + data.message.id);
                        ControlsManager.updateBadges();
                    } else {
                        $('#error_explanation').removeClass('hidden');
                        $('#error_explanation_list').empty();
                        $.each(data.message, function(index, value) {
                            $('#error_explanation_list').append('<li>' + value + '</li>');
                        });
                    }
                });
            });
        });
    }

    // playlists
    this.index = function() {
        Player.show("myplaylists", function() {
            $('#new_playlist').click(function(event) {
                // Stop form from submitting normally
                event.preventDefault();
                Playlists.new();
            });
        });
    }

}
