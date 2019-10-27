= Cal Feed

I'm an umbrella project for sucking in calendar information from "bad" sources,
and aggregating it into nice iCalendar feeds. The sources don't have to be bad,
as iCalendar itself is supported, but if you just need aggregation if iCalendar,
there are better ways to go about it.

You probably want to start by downloading at TSSS calendar page and then run the
app like this-ish:

    ./calfeed.rb load tsss tsss.html

That'll create a `.m` file with the schedule's data in it. Hopefully. If you
run the same command again with a new schedule file, the `.m` file will be
updated with the new content. And more importantly, it'll also record whether a
given event changed (so `SEQUENCE` can be set right).

The filename (`tsss.html` in this case) is used as the remote calendar's key,
so you must ensure you use the same filename for successive runs of the same
calendar _and_ that you use distinct filenames for different calendars.

== TSSS Schedules

TSSS has the ability to publish `.ics` files, so you might think this isn't
needed, but the feature's not available in every edition. So we fake it. Of
notable import, the HTML schedule pages do not provide any sort of identifier
for a game, so the row order on the page is used, start with `1`. It's not
great, but it works. The consequence of this is that if you want to keep
historical calendar information across season changes, you'll need to use a
filename _per season_, not just per team. If you don't, the first game of
the new season will be considered an "update" of the first game of the prior
season.

This seems pretty silly, and it is, but it doesn't really have much impact
in practice.
