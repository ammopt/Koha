use Modern::Perl;

return {
    bug_number => "30275",
    description => "Add a checkout_renewals table",
    up => sub {
        my ($args) = @_;
        my ($dbh, $out) = @$args{qw(dbh out)};
        unless ( TableExists('checkout_renewals') ) {
            $dbh->do(q{
                CREATE TABLE `checkout_renewals` (
                  `id` int(11) NOT NULL auto_increment,
                  `issue_id` int(11) DEFAULT NULL COMMENT 'the id of the issue this renewal pertains to',
                  `renewer_id` int(11) DEFAULT NULL COMMENT 'the id of the user who processed the renewal',
                  `seen` tinyint(1) DEFAULT 0 COMMENT 'boolean denoting whether the item was present or not',
                  `interface` varchar(16) NOT NULL COMMENT 'the interface this renewal took place on',
                  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'the date and time the renewal took place',
                  PRIMARY KEY(`id`),
                  KEY `renewer_id` (`renewer_id`),
                  CONSTRAINT `renewals_renewer_id` FOREIGN KEY (`renewer_id`) REFERENCES `borrowers` (`borrowernumber`) ON DELETE SET NULL ON UPDATE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            });
            say $out "Added new table 'checkout_renewals'";
        }
    },
}