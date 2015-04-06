//= require utils
//= require musics
//= require playlists
//= require comments

/**
* Player object
* Manages the player's interface.
*/
var Player = new function() {

    //
    // Variables
    //

    this.audio = '';
    this.content = '#ma-player-content';
    this.infos = '';
    this.user = 0;

    //
    // Methods
    //

    /**
    * Connect a function to an element's event.
    * @param  {string}   object   HTML element's ID
    * @param  {string}   event    Event (eg. click)
    * @param  {function} callback Callback function
    */
    this.connect = function(object, event, callback) {
        $(object).on(event, callback);
    }

    this.delete = function(object, id, redirection) {
        $.ajax({
            url: object + '/' + id,
            type: 'DELETE',
            dataType: 'json',
        }).done(function(data) {
            Player.show(redirection);
            ControlsManager.updateBadges();
        });
    }

    /**
    * Show default page
    */
    this.home = function() {
        Player.show('last');
    }

    /**
    * Initialization
    */
    this.initialize = function() {
        // Create an audio element.
        this.audio = new Audio();
        this.audio.autoplay = false;
        this.audio.controls = false;

        // Event listeners
        this.audio.addEventListener("pause", ControlsManager.pause, false);
        this.audio.addEventListener("play", ControlsManager.play, false);
        this.audio.addEventListener("timeupdate", ControlsManager.update, false);

        // Show how many playlists/songs the user has.
        $.getJSON('currentuser', {
            format: "json"
        }).done(function(data) {
            Player.user = data;
            ControlsManager.updateBadges();
        });
    }

    /**
    * Load a new song given by its ID.
    * @param  {int} id File's ID
    */
    this.load = function(id) {
        $.ajax({
            url: 'music/' + id,
            dataType: 'json',
            beforeSend: function(xhr) {
                xhr.overrideMimeType("text/plain; charset=x-user-defined");
            }
        })
        .done(function(data) {
            // Cover
            $('#ma-player-sidebar-cover').attr('src', data.cover);

            // Audio source
            Player.audio.src = data.path;

            // Load and play the audio when it has buffered enough.
            Player.audio.oncanplay = function() {
                Player.infos = data.infos; // Load datas
                ControlsManager.updateInfos(); // Display datas
                ControlsManager.play(); // Change controls to the "playing" mode
                Player.play(); // Start playing audio
            }
        });
    }

    /**
    * Pause the audio.
    */
    this.pause = function() {
        Player.audio.pause();
    }

    /**
    * Play the audio.
    */
    this.play = function() {
        Player.audio.play();
    }

    /**
    * Load a route and show it in the content container.
    * @param  {string} path           Route
    * @param  {function} callbackOnDone Function called when the request is done.
    */
    this.show = function(path, callbackOnDone, data) {
        $.ajax({
            url: path,
            data: data,
            beforeSend: function(xhr) {
                xhr.overrideMimeType("text/plain; charset=x-user-defined");
            }
        })
        .done(function(data) {
            $(Player.content).html(data);
            if (typeof callbackOnDone !== 'undefined')
            callbackOnDone();
        });
    }

    /**
    * Switch the audio's state (playing/paused)
    */
    this.switch = function() {
        var playing = !Player.audio.paused;
        if (playing)
        Player.pause();
        else
        Player.play();
    }
}

var ControlsManager = new function() {

    //
    // Variables
    //

    this.buttonSidebarPlay = '#ma-player-play';
    this.buttonSidebarPlaylists = '#ma-player-sidebar-menu-playlists';
    this.buttonSidebarPlaylistsBadge = '#ma-player-sidebar-menu-playlists-badge';
    this.buttonSidebarSongs = '#ma-player-sidebar-menu-songs';
    this.buttonSidebarSongsBadge = '#ma-player-sidebar-menu-songs-badge';
    this.buttonSidebarUpload = '#ma-player-sidebar-menu-upload';
    this.labelArtist = '#ma-player-sidebar-music-artist';
    this.labelTime = '#ma-player-time';
    this.labelTitle = '#ma-player-sidebar-music-title';

    this.duration = "00:00";

    //
    // Methods
    //

    /**
    * Initialization
    */
    this.initialize = function() {
        // Connect sidebar's buttons.
        Player.connect(this.buttonSidebarPlay, 'click', Player.switch);
        Player.connect(this.buttonSidebarPlaylists, 'click', Playlists.index);
        Player.connect(this.buttonSidebarSongs, 'click', Musics.index);
        Player.connect(this.buttonSidebarUpload, 'click', Musics.new);
    }

    /**
    * Change the Play button to the "pause" state.
    */
    this.pause = function() {
        var button = $('#ma-player-play-icon');
        button.removeClass('fa-pause');
        button.addClass('fa-play');
    }

    /**
    * Change the Play button to the "play" state.
    */
    this.play = function() {
        var button = $('#ma-player-play-icon');
        button.removeClass('fa-play');
        button.addClass('fa-pause');
    }

    /**
    * Switch the audio state in the player.
    */
    this.buttonPlayClicked = function() {
        Player.switch();
    }

    /**
    * Update the controls objects.
    *
    * Called when the audio is playing so it is unecessary to call
    * updateInfos because it is already called when a new song is loaded.
    */
    this.update = function() {
        ControlsManager.updateProgressbar();
        ControlsManager.updateTime();
    }

    /**
    * Update the title/artist labels.
    */
    this.updateInfos = function() {
        this.duration = Utils.formatTime(Player.audio.duration);
        $(ControlsManager.labelTitle).html(Player.infos.title);
        $(ControlsManager.labelArtist).html(Player.infos.artist);
    }

    /**
    * Update the progressbar (occures when the audio is playing).
    */
    this.updateProgressbar = function() {
        // Let the user drag if necessary.
        if (!ProgressBarManager.dragging)
        ProgressBarManager.setValue(Player.audio.currentTime / Player.audio.duration * 100);
    }

    /**
    * Update current time in the label.
    */
    this.updateTime = function() {
        var currentTime = Utils.formatTime(Player.audio.currentTime);
        $(this.labelTime).html(currentTime + " / " + this.duration);
    }

    this.updateBadges = function() {
        $.getJSON('player/badges', {
            format: "json"
        }).done(function(data) {
            $(ControlsManager.buttonSidebarPlaylistsBadge).html(data.playlists);
            $(ControlsManager.buttonSidebarSongsBadge).html(data.musics);
        });
    }
}

/**
* ProgressBar manager
*
* TODO: There's a bug in the handler's stop method. Go check it out.
*/
var ProgressBarManager = new function() {

    //
    // Variables
    //

    this.bar = $('#ma-player-progressbar-bar');
    this.container = $('#ma-player-progressbar');
    this.handler = $('#ma-player-progressbar-handler');

    this.bounds = new Bounds(0, 0, 0, 0);
    this.dragging = false;

    var value = 0;
    var size = 100;

    //
    // Methods
    //

    /**
    * Initialization
    */
    this.initialize = function() {
        // Just some shortcuts for this method.
        var bar = ProgressBarManager.bar;
        var container = ProgressBarManager.container;
        var handler = ProgressBarManager.handler;

        this.recalcBounds();

        // Make the handler draggable.
        this.handler.draggable({
            axis: 'x',
            containment: [
                this.bounds.x1,
                this.bounds.y1,
                this.bounds.x2,
                this.bounds.y2
            ],
            drag: function(event, ui) {
                var left = handler.position().left - container.position().left + (handler.width() / 2);
                var width = container.width();

                value = left / width * size;
                ProgressBarManager.setValue(value);
            },
            start: function(event, ui) {
                ProgressBarManager.dragging = true;
            },
            stop: function(event, ui) {
                ProgressBarManager.dragging = false;
                ProgressBarManager.updateAudio();
                // TODO : The audio is resuming after this when paused. SOMEONE FIX THIS PLZ 8(
            }
        });

        // Click handler
        this.container.click(function(e) {
            var value = (e.pageX - container.position().left) / container.width() * size;
            ProgressBarManager.setValue(value);
            ProgressBarManager.updateAudio();
        });

        this.updateHandler();
    }

    /**
    * Recompute the progress bar's boundaries.
    */
    this.recalcBounds = function() {
        var startX = this.container.position().left - (this.handler.width() / 2);
        var endX = startX + this.container.width();
        var startY = this.container.position().top; - (this.handler.height() / 4);

        this.bounds.x1 = startX;
        this.bounds.y1 = startY;
        this.bounds.x2 = endX;
        this.bounds.y2 = startY;
    }

    /**
    * Change the progress bar's value.
    * @param {float} val Value from 0 to 100
    */
    this.setValue = function(val) {
        this.value = val;

        this.bar.css('width', this.value + '%');
        this.bar.attr('aria-valuenow', this.value);

        var left = this.container.position().left + this.bar.width();
        this.handler.css({
            left: left - (this.handler.width() / 2),
            top: this.container.position().top - (this.handler.height() / 4)
        });
    }


    /**
    * Update handler's position.
    */
    this.updateHandler = function() {
        var left = this.container.position().left + this.bar.width();
        this.handler.css({
            left: left - (this.handler.width() / 2),
            top: this.container.position().top - (this.handler.height() / 4)
        });
        this.handler.draggable(
            "option",
            "containment",
            [
                this.bounds.x1,
                this.bounds.y1,
                this.bounds.x2,
                this.bounds.y2
            ]);
    }

    /**
    * Send the new position to the audio.
    */
    this.updateAudio = function() {
        Player.audio.currentTime = Player.audio.duration / 100 * this.value;
    }
}

var NavbarManager = new function() {

    //
    // Variables
    //

    this.buttonHome = '#ma-player-navbar-home';
    this.buttonSearch = '#search-submit';
    this.inputSearch = '#search-input';

    //
    // Methods
    //

    /**
    * Initialization
    */
    this.initialize = function() {
        Player.connect(this.buttonHome, 'click', Player.home);

        // Weird but working call for search functionality.
        // TODO : Improve this.
        $(this.buttonSearch).on('click', function(){
            return $(NavbarManager.inputSearch).val();
        }, Musics.search);
    }
}


//
// Window / Document section
//

$(window).resize(function() {
    ProgressBarManager.recalcBounds();
    ProgressBarManager.updateHandler();
});

$(document).ready(function() {
    Player.initialize();
    NavbarManager.initialize();
    ProgressBarManager.initialize();
    ControlsManager.initialize();

    Player.home();
});
