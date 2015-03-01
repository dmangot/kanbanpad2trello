# kanbanpad2trello
Simple script to do a one time import of Kanbanpad projects to Trello boards (including all tasks/cards)

Kanbanpad is shutting down.   I needed to get my data out and put it in another system for my personal kanban boards.

I wanted to put my data in LeanKit but their basic package does not include the ability to share private boards
which is a dealbreaker for me.

This was tested on Ruby 2.2.0.   You will need the gems in the Gemfile and the appropriate usernames and keys
for the 'XXXX' fields in the code.

This does not import colors but it does import comments.   My colors were all a mess anyway.
