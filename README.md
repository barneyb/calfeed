# Cal Feed

I'm an umbrella project for sucking in calendar information from "bad" sources,
and aggregating it into nice iCalendar feeds. The sources don't have to be bad,
as iCalendar itself is supported, but if you just need aggregation of iCalendar,
there are better ways to go about it.

The app has two dependencies: Ruby >2.3 and the `icalendar` gem. So make sure
you have those first:

    $ ruby --version
    ruby 2.3.3p222 (2016-11-21 revision 56859)
    $ gem list | grep icalendar
    icalendar (2.5.3)

## Usage

The entrypoint to everything is `calfeed.rb`, which always takes a subcommand
and usually some additional params to control it:

    ./calfeed.rb <cmd> <params>

The available subcommands are `load` and `generate`. The former sucks in one
of those "bad" sources and parses it into an intermediate representation. The
latter takes a set of loaded datasets, aggregates them, and emits and `.ics`
file.

Since the commands can get a bit unweildy - and you'll want to be running them
from `cron` anyway - I highly recommend a "work" directory somewhere to house
the files w/ a `run.sh` script that gathers the series of `curl`, `calfeed.rb`,
and `rsync` commands need to actually make it useful.

### Loading

You probably want to start by downloading a TSSS calendar page and then run the
app like this-ish:

    ./calfeed.rb load tsss tsss.html

That'll create a `.m` file with the schedule's data in it. Hopefully. If you
run the same command again with a new schedule file, the `.m` file will be
updated with the new content. And more importantly, it'll also record whether a
given event changed (so `SEQUENCE` can be set right).

The filename (`tsss.html` in this case) is used as the remote calendar's key,
so you must ensure you use the same filename for successive runs of the same
calendar _and_ that you use distinct filenames for different calendars.

The `tsss` parser accepts an optional timezone specification after the input
file should you wish to interpret the dates in something other than your
system's local time.

In addition to the `tsss` loader, there is also a `osaa` loader which reads
OSAA CSV files (from osaa.org).

    ./calfeed load osaa osaa.csv MySchool

The school name is needed because the CSV doesn't indicate which team the CSV
is for, just which team is home and which is away. Specifying the school name
allows the parser to decide which games are home and away for _your school_,
which is almost certainly what you want.

The `osaa` parser also accepts an optional timezone specification after the
school name should you wish to interpret the dates in something other than your
system's local time. This one, however, is mostly to deal with the stupidity
around Oregon's DST legislature (futureproofing for next fall), since it's
unlikely to be useful for anyone outside Oregon.

Finally, there's an `ical` (aliased to `ics`) parser which will read in an
iCalendar file to be aggregated with other sources. It takes the zero-based
index of the calendar in the `.ics` file you want to read, defaulting to zero.

### Generating

Once you've done that at least once, then you can generate an `.ics` file from
one or more sources:

    ./calfeed.rb generate agg.ics tsss.html osaa.csv

List as many sources as you want after the output filename to build a custom
aggregate. Note that the actual source files aren't used, only their
corresponding `.m` file (the sources are just keys).

## TSSS Specific Notes

TSSS has the ability to publish `.ics` files, so you might think this isn't
needed, but the feature's not available in every edition. So we fake it. Of
notable import, the HTML schedule pages do not provide any sort of identifier
for a game, so the row position in the table is used, start with `1`. It's not
great, but it works. The consequence of this is that if you want to keep
historical calendar information across season changes, you'll need to use a
filename _per season_, not just per team. If you don't, the first game of
the new season will be considered an "update" of the first game of the prior
season.

This seems pretty silly, and it is, but it doesn't really have much impact
in practice.
