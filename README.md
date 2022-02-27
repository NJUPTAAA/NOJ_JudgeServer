# NOJ JudgeServer
![NOJ JudgeServer](noj_banner.png)

![Travis (.org)](https://img.shields.io/travis/NJUPTAAA/NOJ_JudgeServer.svg?style=flat-square)

JudgeServer for NOJ, inspired by QDUOJ.

## DockerHub

This package is available on [DockerHub](https://hub.docker.com/repository/docker/njuptaaa/judge_server).

Docker image:
```bash
docker pull njuptaaa/judge_server
```

## Babel Extension NOJ

NOJ JudgeServer is driven by Babel Extension NOJ, see [Babel Extension NOJ](https://github.com/ZsgsDesign/NOJ/tree/master/app/Babel/Extension/noj) and [NOJ BABEL Github Public Mirror](https://njuptaaa.github.io/babel/) for more information.

## All Supported Languages and Examples

|Language|Compile/Run Command|
|--------|-------------------|
|C|/usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c99 {src_path} -lm -o {exe_path}|
|C++|/usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++11 {src_path} -lm -o {exe_path}|
|Java|/usr/bin/javac {src_path} -d {exe_dir} -encoding UTF8<br>/usr/bin/java -cp {exe_dir} -XX:MaxRAM={max_memory}k -Djava.security.manager -Dfile.encoding=UTF-8 -Djava.security.policy==/etc/java_policy -Djava.awt.headless=true Main|
|Python2|/usr/bin/python -m py_compile {src_path}<br>/usr/bin/python {exe_path}|
|Python3|/usr/bin/python3.7 -m py_compile {src_path}<br>/usr/bin/python3.7 {exe_path}|
|PHP7|/usr/bin/php {exe_path}|
|Javascript|/usr/bin/jsc {exe_path}|
|Go|/usr/bin/go build -o {exe_path} {src_path}|
|C#|/usr/bin/mcs -optimize+ -out:{exe_path} {src_path}|
|Ruby|/usr/bin/ruby {exe_path}|
|Rust|/usr/bin/rustc -O -o {exe_path} {src_path}|
|Haskell|/usr/bin/ghc -O -outputdir /tmp -o {exe_path} {src_path}|
|Free Pascal|/usr/bin/fpc -O2 -o{exe_path} {src_path}|
|Plaintext|/bin/cat {exe_path}|
|Free Basic|/usr/local/bin/fbc {src_path}|

## Special Judge Support

### SPJ Libraries

Starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, NOJ JudgeServer provides a SPJ library called **nojlib**, it contains some useful constants and definitions. 

Also starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, **testlib** would be bundled as a optional SPJ library of `C++`.

Right now **nojlib** and **testlib** would be the only two SPJ libraries but we are planning to support more SPJ libraries in the future.

### SPJ Languages

NOJ JudgeServer provides SPJ support for `C` only prior to `v0.3.0`.

Starting from NOJ `v0.18.0` and NOJ JudgeServer `v0.3.0`, NOJ JudgeServer provides support for `C++`, `Java` and `Python3`.

|Language|Additional SPJ Libraries|
|--------|-------------------|
|C|nojlib|
|C++|nojlib, testlib|
|Java|nojlib|
|Python3|nojlib|