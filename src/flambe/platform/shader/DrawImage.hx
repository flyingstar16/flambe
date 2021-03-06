//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe.platform.shader;

import format.hxsl.Shader;

/**
 * Shader that draws textured triangles with a given alpha.
 */
class DrawImage extends Shader
{
    static var SRC = {
        var input :{
            pos :Float2,
            uv :Float2,
            alpha :Float,
        };

        var _uv :Float2;
        var _alpha :Float;

        function vertex (proj :Matrix) {
            _uv = uv;
            _alpha = alpha;
            out = pos.xyzw * proj;
        }

        function fragment (texture :Texture) {
            var color = texture.get(_uv);
            color.a *= _alpha;
            out = color;
        }
    }
}
