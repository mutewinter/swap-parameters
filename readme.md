<pre>
       _____                         ____                                  __
      / ___/_      ______ _____     / __ \____ __________ _____ ___  ___  / /____  __________
      \__ \| | /| / / __ `/ __ \   / /_/ / __ `/ ___/ __ `/ __ `__ \/ _ \/ __/ _ \/ ___/ ___/
     ___/ /| |/ |/ / /_/ / /_/ /  / ____/ /_/ / /  / /_/ / / / / / /  __/ /_/  __/ /  (__  )
    /____/ |__/|__/\__,_/ .___/  /_/    \__,_/_/   \__,_/_/ /_/ /_/\___/\__/\___/_/  /____/
                       /_/
</pre>

# Description

Swap parameters of a function or a comma separated list with a single command.

# Usage

In normal mode, these key commands will swap parameters:

* `[count]gs` Swap the parameter under the cursor with the next one.
* `[count]gS` Swap the current parameter with the previous parameter.

_Note: `[count]` defaults to `1`._

# Installation

_Note: Requires vim compiled with python support. To check if you have python
support, run `vim --version | grep python` and see if it says `+python`._

**Vundle**

1. Add `Bundle 'mutewinter/swap-parameters'` to your `.vimrc` file.
2. Restart Vim.
3. Now run `:BundleInstall`.
4. Enjoy.

# Customization

You can change mappings by using the `g:SwapParametersMapForwards` and
`g:SwapParametersMapBackwards` variables:
```vim
g:SwapParametersMapForwards = '<leader>s'
g:SwapParametersMapBackwards = '<leader>S'
```

# Examples

Below are examples of what happens after pressing gs (equivalent to 1gs).
On each line the left side shows the line before typing gs, and the right
side shows the effect. The cursor position is depicted with || symbols.
par|m|1 means that the cursor is on the character m.

<pre>
             fun(par|m|1, parm2)                    fun(parm2, parm|1|)
           fun(par|m|1(), parm2)                  fun(parm2, parm1(|)|)
           fun(parm1(|)|, parm2)                  fun(parm2, parm1(|)|)
   fun(parm|1|(arg,arg2), parm2)          fun(parm2, parm1(arg,arg2|)|)
   fun(parm1|(|arg,arg2), parm2)          fun(parm2, parm1(arg,arg2|)|)
   fun(parm1(arg,arg2|)|, parm2)          fun(parm2, parm1(arg,arg2|)|)
  fun(parm1(arg, arg2|)|, parm2)         fun(parm2, parm1(arg, arg2|)|)
         fun(arg1, ar|g|2, arg3)                fun(arg1, arg3, arg|2|)
             array[a|r|g1, arg2]                    array[arg2, arg|1|]
           fun(par|m|1[], parm2)                  fun(parm2, parm1[|]|)
           fun(parm1[|]|, parm2)                  fun(parm2, parm1[|]|)
           fun(par|m|1, array[])                  fun(array[], parm|1|)
                      fun(|a|,b)                             fun(b,|a|)
                [(p1, p2|)|, p3]                       [p3, (p1, p2|)|]
 for |a|, b in some_dict.items()        for b, |a| in some_dict.items()
</pre>

 The following lines demonstrate using gS (swap with previous).

<pre>
             fun(parm2, par|m|1)                    fun(|p|arm1, parm2)
           fun(parm2, par|m|1())                  fun(|p|arm1(), parm2)
           fun(parm2, parm1(|)|)                  fun(|p|arm1(), parm2)
   fun(parm2, parm|1|(arg,arg2))          fun(|p|arm1(arg,arg2), parm2)
   fun(parm2, parm1|(|arg,arg2))          fun(|p|arm1(arg,arg2), parm2)
   fun(parm2, parm1(arg,arg2|)|)          fun(|p|arm1(arg,arg2), parm2)
  fun(parm2, parm1(arg, arg2|)|)         fun(|p|arm1(arg, arg2), parm2)
         fun(arg1, ar|g|2, arg3)                fun(|a|rg2, arg1, arg3)
         fun(arg1, arg2, ar|g|3)                fun(arg1, |a|rg3, arg2)
             array[arg2, a|r|g1]                    array[|a|rg1, arg2]
           fun(parm2, par|m|1[])                  fun(|p|arm1[], parm2)
           fun(parm2, parm1[|]|)                  fun(|p|arm1[], parm2)
           fun(array[], par|m|1)                  fun(|p|arm1, array[])
                      fun(b,|a|)                             fun(|a|,b)
 for a, |b| in some_dict.items()        for |b|, a in some_dict.items()
</pre>

 The above examples are auto-generated from the tests.

 Dot repeats don't work with this binding but pressing gs is quick enough I
 think.

 The column position of the cursor is preserved when you go to the next
 line after swap. This allows for streamlined swapping of parameters in the
 case like this:

<pre>
 fun(arg2, blah)
 fun(arg2, blahble)
 fun(arg2, blahblahblah)
</pre>

 You would put cursor on arg2, and the gsjgsjgs


 This script is written in python. Therefore it needs Vim compiled with
 +python option (:version), as well as Python installed in the system.

# About

<table>
  <tbody>
    <tr>
      <th>Author</th><td>Kamil Dworakowski &lt;kamil-at-dworakowski.name&gt;</td>
    </tr>
    <tr>
      <th>Updated By</th><td>Jeremy Mack <a href="http://twitter.com/mutewinter">@mutewinter</a></td>
    </tr>
    <tr>
      <th>Version</th><td>1.2.1</td>
    </tr>
    <tr>
      <th>Last Change</th><td>2012-09-06</td>
    </tr>
    <tr>
      <th>URL</th><td>https://github.com/mutewinter/swap-parameters</td>
    </tr>
    <tr>
      <th>Requires</th><td>Python and Vim compiled with +python option</td>
    </tr>
    <tr>
      <th>Licence</th><td>MIT Licence</td>
    </tr>
  </tbody>
</table>
