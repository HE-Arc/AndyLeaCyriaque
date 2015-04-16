/**
 * Musics pages handlers
 */
var Musics = new function() {
	
	// musics/id/edit
	this.edit = function(id) {
		Player.show('musics/' + id + '/edit', function() {
			$('.edit_music').submit(function(event) {
                // Stop form from submitting normally
                event.preventDefault();
				
				// Show the spinner.
				$('#new_music_submit_spinner').removeClass('hidden');

                // Handle data submission
                $.ajax({
                    url: $(this).attr('action'),
                    type: 'POST',
                    data: new FormData(this),
                    dataType: 'json',
                    processData: false,
                    contentType: false,
                }).done(function(data) {
                    if (data.status == 'updated') {
                        Musics.index();
                    } else {
						$('#new_music_submit_spinner').addClass('hidden'); // Hide the spinner.
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
				
				// Show the spinner.
				$('#new_music_submit_spinner').removeClass('hidden');

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
                        Musics.show(data.message.id);
                        ControlsManager.updateBadges();
                    } else {
						$('#new_music_submit_spinner').addClass('hidden'); // Hide the spinner.
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
