/**
 * Musics pages handlers
 */
var Musics = new function() {

    // musics/index
    this.index = function() {
        Player.show('mymusics');
    }

    this.search = function(event) {
        Player.show('search', function(){
          // nothing
        }, {search: event.data()});
    }

    // musics/new
    this.new = function() {
        Player.show('musics/new', function() {
            $('#new_music').submit(function(event) {
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
                        Player.show('music/' + data.message.id);
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

    this.show = function(id) {
        Player.show('musics/' + id, function() {
            Comments.new(id); // Connect the comment form.
        });
    }

}
