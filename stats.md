# Benchmarking statistics

I'm timing the average request length of different episode_data load schemes.


## Test procedure

- Reset the database to the latest dump from heroku.
- Load the `#/recent` page 3 times.
- Rung `./timing` and record the values here.

### Original
total     1679ms
requests  15
average   111ms

### None
episode.episode_data equals nil
total     1902ms
requests  20
average   95ms

### find_by
total     1615ms
requests  15
average   107ma

### find_by with index
total     1664ms
requests  15
average   110ms
