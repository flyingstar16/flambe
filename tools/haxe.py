"""
Basic haXe compiler support for Waf
"""

import os, re
from waflib.Configure import conf
from waflib import TaskGen, Task, Utils, Options, Build, Errors, Node
from waflib.TaskGen import feature, before_method, after_method

from waflib.Tools import ccroot

def configure(self):
    # If HAXE_HOME is set, we prepend it to the path list
    path = self.environ["PATH"].split(os.pathsep)

    if "HAXE_HOME" in self.environ:
        path = [self.environ["HAXE_HOME"]] + path
        self.env["HAXE_HOME"] = [self.environ["HAXE_HOME"]]

    self.find_program("haxe", var="HAXE", path_list=path)

# Borrowed from the scalac task
class haxe(Task.Task):
    color = "BLUE"
    vars = [ "flags" ] # Depend on these env var as inputs

    def scan(self):
        sources = []
        for cp in self.classpath:
            sources += cp.ant_glob("**/*.hx")
        return (sources, [])

    def run(self):
        """
        Execute the haxe compiler
        """
        env = self.env
        gen = self.generator
        bld = gen.bld
        wd = bld.bldnode.abspath()
        def to_list(xx):
            if isinstance(xx, str): return [xx]
            return xx
        self.last_cmd = lst = []
        lst.extend(to_list(env.HAXE))
        for cp in self.classpath:
            lst.extend(["-cp", cp.abspath()])
        lst.extend(self.env.flags)
        return self.generator.bld.exec_command(lst, cwd=wd, env=env.env or None)

    def __str__(self):
        env = self.env
        tgt_str = " ".join([a.nice_path(env) for a in self.outputs])
        return "%s: %s\n" % (self.__class__.__name__.replace("_task", ""), tgt_str)

@feature("haxe")
def apply_haxe(self):
    Utils.def_attrs(self,
        target="", classpath="", flags="", libs="", swflib=None);

    classpath = Utils.to_list(self.classpath)
    flags = Utils.to_list(self.flags)
    target = self.target;

    inputs = []

    if target.endswith(".swf"):
        flags += ["-swf", target, "--flash-strict", "-D", "nativeTrace"]
        if (self.swflib is not None):
            swflib = self.path.get_bld().make_node(self.swflib)
            inputs += [swflib]
            flags += ["-swf-lib", str(swflib)]
    elif target.endswith(".js"):
        flags += ["-js", target]
    elif target.endswith(".n"):
        flags += ["-neko", target]
    else:
        raise "Unsupported target file type!"

    for lib in Utils.to_list(self.libs):
        flags += ["-lib", lib]

    task = self.create_task("haxe", inputs, self.path.get_bld().make_node(target))
    task.classpath = [self.path.find_node(cp) for cp in classpath]
    task.env.flags = flags
    self.haxe_task = task
