//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe.debug;

import flambe.display.TextSprite;
import flambe.math.FMath;

/**
 * A component that uses its entity's TextSprite to display an FPS log.
 */
class FpsDisplay
    extends Component
{
    public function new ()
    {
    }

    override public function onUpdate (dt)
    {
        ++_fpsFrames;
        _fpsTime += dt;
        if (_fpsTime > 1000) {
            var fps = 1000 * _fpsFrames/_fpsTime;
            owner.get(TextSprite).text = "FPS: " + FMath.toInt(fps*100) / 100;
            _fpsTime = _fpsFrames = 0;
        }
    }

    private var _fpsFrames :Int;
    private var _fpsTime :Int;
    private var _lastTime :Int;
}
