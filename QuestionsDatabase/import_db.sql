DROP TABLE if EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE if EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE if EXISTS question_follows;

CREATE TABLE question_follows (
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE if EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_reply_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

DROP TABLE if EXISTS question_likes;

CREATE TABLE question_likes (
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Nicole', 'Hemenway'),
  ('Daniel', 'Fletcher'),
  ('Debra', 'Joe'),
  ('Scooby', 'Doo');

INSERT INTO
  questions (subject, body, user_id)
VALUES
  (
    'Animals??!',
    'Where the heck were all the animals in SQLZoo??? I FEEL LIKE I''M TAKING CRAZY PILLS',
    (SELECT id FROM users WHERE fname = 'Nicole')
  ),
  (
    'Ticket prices....?',
    'I paid $2.99 for WHAT?!',
    (SELECT id FROM users WHERE fname = 'Daniel')
  ),
  (
    'coffee break?',
    'what time is the coffee break? do we have on?',
    (SELECT id FROM users WHERE fname = 'Nicole')
  ),
  (
    'Scooby?',
    'What''s Scooby''s lname?',
    (SELECT id FROM users WHERE fname = 'Debra')
  );

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (
    (SELECT id FROM questions WHERE subject = 'Animals??!'),
    (SELECT id FROM users WHERE fname = 'Daniel')
  ),
  (
    (SELECT id FROM questions WHERE subject = 'Animals??!'),
    (SELECT id FROM users WHERE fname = 'Nicole')
  ),
  (
    (SELECT id FROM questions WHERE subject = 'Ticket prices....?'),
    (SELECT id FROM users WHERE fname = 'Daniel')
  );

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (
    (SELECT id FROM questions WHERE subject = 'Ticket prices....?'),
    (SELECT id FROM users WHERE fname = 'Nicole')
  ),
  (
    (SELECT id FROM questions WHERE subject = 'Scooby?'),
    (SELECT id FROM users WHERE fname = 'Nicole')
  ),
  (
    (SELECT id FROM questions WHERE subject = 'Scooby?'),
    (SELECT id FROM users WHERE fname = 'Scooby')
  ),
  (
    (SELECT id FROM questions WHERE subject = 'Scooby?'),
    (SELECT id FROM users WHERE fname = 'Debra')
  ),
  (
    (SELECT id FROM questions WHERE subject = 'Scooby?'),
    (SELECT id FROM users WHERE fname = 'Daniel')
  ),
  (
    (SELECT id FROM questions WHERE subject = 'coffee break?'),
    (SELECT id FROM users WHERE fname = 'Debra')
  ),
  (
    (SELECT id FROM questions WHERE subject = 'coffee break?'),
    (SELECT id FROM users WHERE fname = 'Nicole')
);

INSERT INTO
  replies (body, question_id, user_id, parent_reply_id)
VALUES
  (
    'WE WANT ANSWERS',
    (SELECT id FROM questions WHERE subject = 'Animals??!'),
    (SELECT id FROM users WHERE fname = 'Daniel'),
    NULL
  ),
  (
    'on rails',
    (SELECT id FROM questions WHERE subject = 'Scooby?'),
    (SELECT id FROM users WHERE fname = 'Scooby'),
    NULL
  );

INSERT INTO
    replies (body, question_id, user_id, parent_reply_id)
VALUES
  (
    'ya srsly',
    (SELECT id FROM questions WHERE subject = 'Animals??!'),
    (SELECT id FROM users WHERE fname = 'Nicole'),
    (SELECT id FROM replies WHERE body = 'WE WANT ANSWERS')
  );
