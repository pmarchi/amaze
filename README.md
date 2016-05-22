[![Gem Version](https://badge.fury.io/rb/amaze.svg)](https://badge.fury.io/rb/amaze)

# Amaze

Amaze is both a ruby library and a command line tool to generate mazes.

I love mazes. The beauty of mazes have always fascinated me. Amaze is a personal project to create mazes with different tesselations, shapes and sizes. The wonderful book of Jamis Buck, [Mazes for Programmers: Code Your Own Twisty Little Passages](https://pragprog.com/book/jbmaze/mazes-for-programmers) was a great source of inspiration. To adapt the ideas, the code and add my own little twists was a lot of fun.

Visit [Think Labyrinth: Maze Algorithms](http://www.astrolog.org/labyrnth/algrithm.htm) if you want to explore more on mazes, their classification, creation and solving algorithms.


## Installation

Amaze depends on [RMagick](https://github.com/rmagick/rmagick) to generate png images. RMagick is an interface between the Ruby programming language and the [ImageMagick](http://www.imagemagick.org) image processing library. You have to install imagemagick first before installing amaze.

On **OS X** install imagemagick with brew

    $ brew install imagemagick

Then run

    $ gem install amaze


## Usage

Execute `amaze --help` for a short description of all supported options.

Generate a simple ASCII maze

    $ amaze

    +---+---+---+---+
    |               |
    +   +---+   +---+
    |       |       |
    +   +---+---+   +
    |   |           |
    +   +   +---+   +
    |   |   |       |
    +---+---+---+---+
    Growing tree (last from list) algorithm: 0.00012327899457886815s
    Dead ends: 5 of 16 (31%)
    Random seed: 130944739226911434163498228124148718585

Make it a little bigger

    $ amaze -g 12

How about a sigma grid

    $ amaze --type sigma
    
     ___     ___
    /   \___/   \___
    \        ___    \
    /   \___/    ___/
    \   /    ___/   \
    /   \   /   \   /
    \   /   \       \
    /   \___/   \   /
    \___     ___/   \
        \___/   \___/
    Growing tree (last from list) algorithm: 0.00015847600298002362s
    Dead ends: 3 of 16 (18%)
    Random seed: 210159208462445383832077802753403683598

Want to visualize the longest path through the maze (it will be nicely colored in your terminal)

    $ exe/amaze --longest
    
    +---+---+---+---+
    | ∙ | ∙-------∙ |
    + | + | +---+ | +
    | | | ∙---∙ | ∙ |
    + | +---+ | +---+
    | ∙---∙ | ∙---∙ |
    +---+ | +---+ | +
    |     ∙-------∙ |
    +---+---+---+---+
    Growing tree (last from list) algorithm: 0.00013193400809541345s
    Dead ends: 3 of 16 (18%)
    Path length: 14
    Random seed: 21088416182148741326253564379123099432
    
How about watching the algorithm doing its work?

    $ amaze --visualize

![Watching the alogorithm generating a maze](support/images/algorithm_animation.gif?raw=true "Visualize Algorithm")

You can choose between different algorithm (try Hunt and Kill next)

    $ amaze --visualize --algorithm hk

Finally you can render your maze as PNG

    $ amaze --format=image
    Growing tree (last from list) algorithm: 0.00013603299157693982s
    Dead ends: 3 of 16 (18%)
    Random seed: 72618483828743227022428199116847991100
    Maze 'maze.png' saved.

... and a last example

    $ amaze --type ortho -g 12 --format image --distances --longest

will render something like this:

![Image of an ortho maze with color coded distances and longest path](support/images/maze_ortho_distances_longest.png?raw=true "Beautiful Maze")

Amaze has a lot more options to play with. Have fun and create beautiful pieces of [algorithmic art](https://en.wikipedia.org/wiki/Algorithmic_art).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pmarchi/amaze.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
