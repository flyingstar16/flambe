//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe;

import flambe.util.Disposable;
import flambe.util.Signal0;
import flambe.util.Signal1;
import flambe.util.Signal2;

class Disposer extends Component
{
    public function new ()
    {
        _disposables = [];
    }

    public function add (disposable :Disposable)
    {
        _disposables.push(disposable);
    }

    public function remove (disposable :Disposable)
    {
        _disposables.remove(disposable);
    }

    public function connect0 (signal :Signal0, listener :Listener0)
    {
        add(signal.connect(listener));
    }

    public function connect1<A> (signal :Signal1<A>, listener :Listener1<A>)
    {
        add(signal.connect(listener));
    }

    public function connect2<A,B> (signal :Signal2<A,B>, listener :Listener2<A,B>)
    {
        add(signal.connect(listener));
    }

    override public function onDispose ()
    {
        var disposables = _disposables;
        _disposables = [];
        for (d in disposables) {
            d.dispose();
        }
    }

    private var _disposables :Array<Disposable>;
}
