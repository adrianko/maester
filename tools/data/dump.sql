INSERT INTO `board` VALUES (1, 'Development', 'dev stuff', '23719f');
INSERT INTO `board` VALUES (2, 'Design', 'design stuff', 'bd6f32');
INSERT INTO `category` VALUES (1, 1, 'Backlog', 1);
INSERT INTO `category` VALUES (2, 1, 'Deployed', 3);
INSERT INTO `category` VALUES (3, 1, 'In Progress', 2);
INSERT INTO `category` VALUES (4, 2, 'Stuff', 1);
INSERT INTO `task` VALUES (1, 1, 'A task', 'something here', 1, 3600, 1402149032);
INSERT INTO `task` VALUES (2, 1, 'Another task', 'something else here', 2, 7200, 1402235741);
INSERT INTO `user` VALUES (1, 'ak', 'akcodes3@gmail.com');
INSERT INTO `user` VALUES (2, 'mb', 'a@b.c');
INSERT INTO `task_users` VALUES (1, 1, 1);
INSERT INTO `task_users` VALUES (2, 1, 2);
INSERT INTO `task_users` VALUES (3, 2, 1);
