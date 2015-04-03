/**
 * Musics pages handlers
 */
var Playlists = new function() {

    this.new = function() {
        Player.load("playlists/new", function() {
            $('#back').click(function(event) {
                // Stop form from submitting normally
                event.preventDefault();
                Playlists.show();
            });
        });
    }

    // playlists
    this.index = function() {
        Player.load("playlists", function() {
            $('#new_playlist').click(function(event) {
                // Stop form from submitting normally
                event.preventDefault();
                Playlists.new();
            });
        });
    }

}
