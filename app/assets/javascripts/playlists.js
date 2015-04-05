/**
 * Musics pages handlers
 */
var Playlists = new function() {

    this.new = function() {
        Player.show("playlists/new", function() {
            $('#back').click(function(event) {
                // Stop form from submitting normally
                event.preventDefault();
                Playlists.index();
            });
        });
    }

    // playlists
    this.index = function() {
        Player.show("playlists", function() {
            $('#new_playlist').click(function(event) {
                // Stop form from submitting normally
                event.preventDefault();
                Playlists.new();
            });
        });
    }

}
