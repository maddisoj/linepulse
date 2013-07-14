## LinePulse

LinePulse is a small plugin to pulse the current cursor's line when you lose
track of it.

## Screenshot

Below is a demo of LinePulse working with the default settings.

![LinePulse Demo](https://github.com/lerp/linepulse/raw/master/resources/example.gif)

## Installation with Vundle (Recommended)

Installing LinePulse is easy with [Vundle](https://github.com/gmarik/vundle).

Just add:

    Bundle 'lerp/linepulse'

to your `.vimrc` file.

## Installation with Pathogen

Installation with [Pathogen](https://github.com/tpope/vim-pathogen) is just as
easy.

Download LinePulse and extract it's contents into `~/.vim/bundle/`

## Usage

It's really rather simple. Just call `:DoPulse` (I would suggest mapping it to
something) and a pulse will be performed.

## Options

You can set:

    * `g:linepulse_start` to change the start colour.
    * `g:linepulse_end` to change the ending colour.
    * `g:linepulse_steps` to change how smoothly the interpolation is.
    * `g:linepulse_time` to set how long it takes to perform a pulse.

More info can be found by doing `:help linepulse-options`

