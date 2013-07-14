let g:linepulse_start = "guibg"
let g:linepulse_end   = "#555"
let g:linepulse_steps = 10
let g:linepulse_time  = 300

" Gets the Normal highlight
function! linepulse#GetNormalHighlight() " {{{
    redir => hi_line
        silent execute "hi Normal"
    redir END

    let hi_line = split(hi_line, "\n")[0]

    echom hi_line

    return hi_line
endfunction " }}}

" Gets the CursorLine highlight
function! linepulse#GetCursorLineHighlight() " {{{
    redir => cursor_line
        silent execute "hi CursorLine"
    redir END

    let cursor_line = split(cursor_line, "\n")[0]

    echom cursor_line

    return cursor_line
endfunction " }}}

" Gets the starting colour
function! linepulse#GetStartColor() " {{{
    return linepulse#GetColorFromOption(
                \   linepulse#GetNormalHighlight(),
                \   g:linepulse_start)
endfunction " }}}

" Gets the end colour
function! linepulse#GetEndColor() " {{{
    return linepulse#GetColorFromOption(
                \   linepulse#GetNormalHighlight(),
                \   g:linepulse_end)
endfunction " }}}

" Takes an option and returns a colour based on the option.
" Valid options are either a highlight string such as guibg or a hexidecimal
" number.
function! linepulse#GetColorFromOption(highlight, option) " {{{
    if a:option[0] ==? "#"
        return a:option
    endif

    " Regex Explanation ---------------------------------------------------- {{{
    " Matches a hex or word preceded by guibg=
    "   \v           - very magic mode
    "   (a:option\=) - a group representing whatever text the user chose
    "   @<=          - tell vim to do a lookbehind, for the previous group this
    "                  way it's not included in the result.
    "   #?\w+        - a optional # then a word
    "   }}}
    return matchstr(a:highlight, '\v(' . a:option . '\=)@<=#?\w+')
endfunction "}}}

" Takes a red, green and a blue value and returns a hexidecimal NUMBER
" equivalent.
function! linepulse#RGBtoHex(red, green, blue) " {{{
    return printf("%02x%02x%02x", a:red, a:green, a:blue)
endfunction " }}}

" Takes a hexidecimal string in the format #ABC[DEF] and converts it to a list
" with the format [ r, g, b, ].
function! linepulse#HexToRGB(hex) " {{{
    let hex_value = a:hex

    if hex_value[0] ==? "#"
        let hex_value = hex_value[1:]
    else
        echoerr "'" . hex_value . "' no leading #"
        return
    endif

    let rgb = [0, 0, 0,]

    if strlen(hex_value) == 6
        let rgb[0] = str2nr(hex_value[0:1], 16)
        let rgb[1] = str2nr(hex_value[2:3], 16)
        let rgb[2] = str2nr(hex_value[4:5], 16)
    elseif strlen(hex_value) == 3
        let rgb[0] = str2nr(hex_value[0] . hex_value[0], 16)
        let rgb[1] = str2nr(hex_value[1] . hex_value[1], 16)
        let rgb[2] = str2nr(hex_value[2] . hex_value[2], 16)
    else
        echoerr "'" . hex_value . "' Hex string not of parseable length"
        return
    endif

    return rgb
endfunction " }}}

" Performs the pulse, fading the cursor line from g:linepulse_start to
" g:linepulse_end with g:linepulse_steps steps inbetween.
function! linepulse#DoPulse() " {{{
    let start_color = linepulse#HexToRGB(linepulse#GetStartColor())
    let end_color   = linepulse#HexToRGB(linepulse#GetEndColor())

    let save_highlight = linepulse#GetColorFromOption(
                \           linepulse#GetCursorLineHighlight(),
                \           "guibg")
    let save_cursor_line = &cursorline
    set cursorline

    for i in range(g:linepulse_steps)
        let current_color = [ 0, 0, 0, ]

        for j in range(3)
            let current_color[j] = start_color[j] + end_color[j]
                        \          * ((i + 0.0) / g:linepulse_steps)
        endfor

        silent execute "hi CursorLine guibg=#" . linepulse#RGBtoHex(
                    \                               float2nr(current_color[0]),
                    \                               float2nr(current_color[1]),
                    \                               float2nr(current_color[2])
                    \                            )
        silent execute "sleep" . g:linepulse_time / g:linepulse_steps . "m"
        redraw
    endfor

    silent execute "hi CursorLine guibg=" . save_highlight
    let &cursorline = save_cursor_line
endfunction " }}}

command! -nargs=0 DoPulse call linepulse#DoPulse()
