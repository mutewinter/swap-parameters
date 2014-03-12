"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" swap_parameters.vim : swap parameters of a function fun(arg2, arg1, arg3)
"                       swap elements in coma separated lists
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author:        Kamil Dworakowski <kamil-at-dworakowski.name>
" Updated By:    Jeremy Mack <@mutewinter>
" Version:       1.2.1
" Last Change:   2012-09-06
" URL:           https://github.com/mutewinter/swap-parameters
" Requires:      Python and Vim compiled with +python option
" Licence:       MIT Licence
" Installation:  Drop into plugin directory
" Basic Usecase: Place the cursor inside the parameter you want to swap
"                with the next one, and press gs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:ErrMsg(msg)
  echohl ErrorMsg
  echo a:msg
  echohl None
endfunction

if !has('python')
  if !exists("g:SwapParametersSuppressPythonWarning") ||
      \ g:SwapParametersSuppressPythonWarning == "0"
    call s:ErrMsg( "Error: swap-parameters requires Vim compiled with +python" )
  endif
  finish
endif

function! SwapParams(directionName)
python << EOF
leftBrackets = ['[', '(']
rightBrackets = [']', ')']

class Direction(object):
    def isOpenBracket(self, char):
        return char in self.openingBrackets

    def isCloseBracket(self, char):
        return char in self.closingBrackets

    def isBackward(self):
        return self.openingBrackets is rightBrackets

    def isForward(self):
        return not self.isBackward()


class RightwardDirection(Direction):
    openingBrackets = leftBrackets
    closingBrackets = rightBrackets
    def opposite(self):
        return LeftwardDirection()

class LeftwardDirection(Direction):
    openingBrackets = rightBrackets
    closingBrackets = leftBrackets
    def opposite(self):
        return RightwardDirection()


def findFirst(predicate, input, direction=None, eolIsDelimiter=False):
    def find(pos=0):
        try:
            head = input.next()
            if predicate(head):
                return pos
            elif direction and direction.isOpenBracket(head):
                charsInsideBrackets = \
                    findFirst(direction.isCloseBracket, input, direction)
                return find(pos + charsInsideBrackets+1 + 1)
            else:
                return find(pos+1)
        except:
            if eolIsDelimiter:
                return pos
            return -1
    return find()


def SwapParams(direction, line, col):

    def areThereNoEnclosinBrackets():
        rightBracketIndex = findFirst(rightBrackets.__contains__,
                                 iter(line[col:]),
                                 RightwardDirection()
        )
        return rightBracketIndex == -1

    noEncloseBrackets = areThereNoEnclosinBrackets()

    def findTheSeparatorBeforeTheLeftParam():
        prefixRev = reversed(line[:col+1])
        toTheLeft = 0
        if line[col] in leftBrackets:
            prefixRev.next()
            toTheLeft += 1

        def findNextLeftSeparator(separators=leftBrackets+[',']):
            return findFirst(separators.__contains__,
                             prefixRev,
                             LeftwardDirection(),
                             eolIsDelimiter=True
            )

        if direction.isForward() and noEncloseBrackets:
            toTheLeft += findNextLeftSeparator(separators=[' '])
        else:
            toTheLeft += findNextLeftSeparator()

        if direction.isBackward() and noEncloseBrackets:
            toTheLeft += 1 + findNextLeftSeparator(separators=[' '])
        elif direction.isBackward():
            toTheLeft += 1 + findNextLeftSeparator()

        return col - toTheLeft + 1

    start = findTheSeparatorBeforeTheLeftParam()

    nonwhitespace = lambda x: x not in (' ', '\t')

    input = iter(line[start:])
    param1start = start + findFirst(nonwhitespace, input)
    param1end = param1start + findFirst(lambda x: x == ',',
            iter(line[param1start:]),
            RightwardDirection()
    ) - 1
    param2start = param1end + 2 + findFirst(nonwhitespace, iter(line[param1end+2:]))
    rightSeparators = rightBrackets + [',']
    if noEncloseBrackets:
        rightSeparators = [' ', ',']
    param2end = param2start - 1 + findFirst(
                                    rightSeparators.__contains__,
                                    iter(line[param2start:]),
                                    RightwardDirection(),
                                    eolIsDelimiter=True)

    if direction.isForward():
        cursorPos = param2end
    else:
        cursorPos = param1start

    return (line[:param1start]
          + line[param2start: param2end+1]
          + line[param1end+1: param2start]
          + line[param1start: param1end+1]
          + line[param2end+1:],
          cursorPos
    )


def Swap(line, col):
    return SwapParams(RightwardDirection(), line, col)

def SwapBackwards(line, col):
    return SwapParams(LeftwardDirection(), line, col)
EOF

if a:directionName == 'backwards'
    python Swap = SwapBackwards
endif

python << EOF
if __name__ == '__main__':
    import vim
    (row,col) = vim.current.window.cursor
    line = vim.current.buffer[row-1]
    try:
        (line, newCol) = Swap(line,col)
        vim.current.buffer[row-1] = line
        vim.current.window.cursor = (row, newCol)
    except Exception, e:
        print e
EOF
endfunction

command! SwapParamsForwards call SwapParams("forwards")
if !exists('g:SwapParametersMapForwards') | let g:SwapParametersMapForwards = 'gs' | en
exe 'nn <silent>' g:SwapParametersMapForwards ':SwapParamsForwards<cr>'

command! SwapParamsBackwards call SwapParams("backwards")
if !exists('g:SwapParametersMapBackwards') | let g:SwapParametersMapBackwards = 'gS' | en
exe 'nn <silent>' g:SwapParametersMapBackwards ':SwapParamsBackwards<cr>'
