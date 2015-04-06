var Comments = new function(){
 
    this.musicId = $("#music_id").val();
  
       this.new = function() {
        Player.show('music/' + musicId, function() {
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
                        Player.show('music/' + data.message.id);
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