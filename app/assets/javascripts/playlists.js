/**
 * Musics pages handlers
 */
var Playlists = new function() {

    this.new = function() {
        $('#back').click(function(event) {
            // Stop form from submitting normally
            event.preventDefault();
            Player.load("/playlists");
        });
    }
    // musics/index
    this.show = function() {
        $('#new_playlist').click(function(event) {
            // Stop form from submitting normally
            event.preventDefault();
            Player.load("playlists/new");
            Playlists.new();
        });
      
    }
}