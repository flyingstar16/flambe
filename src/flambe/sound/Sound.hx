//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe.sound;

interface Sound
{
    /**
     * The length of the sound in milliseconds.
     */
    var duration (getDuration, null) :Float;

    /**
     * Plays the sound once, suitable for one-shot sound effects.
     */
    function play (volume :Float = 1.0) :Playback;

    /**
     * Loops the sound forever, suitable for background music.
     */
    function loop (volume :Float = 1.0) :Playback;
}
