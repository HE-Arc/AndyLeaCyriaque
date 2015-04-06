/**
 * Comments pages handlers
 */
var Comments = new function() {

    this.new = function(id) {
        Player.show('music/' + id, function() {
            $('#new_comment').submit(function(event) {
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
                        Musics.show(id);
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

}
