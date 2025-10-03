# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

use Data::Dumper;

use Kernel::Output::HTML::Dashboard::TicketProfileSearch;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

my ( $UserLogin, $UserID ) = $Helper->TestUserCreate();
ok(
    $UserID,
    "Test user $UserID created",
);

# create required objects
my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
my $ConfigItemObject = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');

# fetch the ids of the intended class, deployment state and incident state
my $ClassList = $GeneralCatalogObject->ItemList(
    Class => 'ITSM::ConfigItem::Class',
);
my %ReverseClassList = reverse %{$ClassList};
my $ClassID = $ReverseClassList{'Country'};

my $DeplStateList = $GeneralCatalogObject->ItemList(
    Class => 'ITSM::ConfigItem::DeploymentState',
);
my %ReverseDeplStateList = reverse %{$DeplStateList};
my $DeplStateID = $ReverseDeplStateList{'Production'};

my $InciStateList = $GeneralCatalogObject->ItemList(
    Class => 'ITSM::Core::IncidentState',
);
my %ReverseInciStateList = reverse %{$InciStateList};
my $InciStateID = $ReverseInciStateList{'Operational'};

my %GroupList = $GroupObject->GroupList();
my %ReverseGroupList = reverse %GroupList;

my $FirstGroupID = $ReverseGroupList{'admin'};
my $SecondGroupID = $ReverseGroupList{'stats'};

# insert five CIs
# the first two CIs belong are from the 'admin' group
# the following two CIs belong to the 'stats' group
# the last one has no group (group_id is null)
my $Count = 1;
my @ConfigItemIDList;
for my $Ord (qw(first second third fourth fifth))
{
    my $GroupID;
    if ($Count < 3) {
        $GroupID = $FirstGroupID;
    }
    elsif ($Count < 5) {
        $GroupID = $SecondGroupID;
    }
    my $ConfigItemID = $ConfigItemObject->ConfigItemAdd(
        ClassID        => $ClassID,
        Name           => "Config Item #$Count",
        DeplStateID    => $DeplStateID,
        InciStateID    => $InciStateID,
        GroupID        => $GroupID,
        Description    => $Ord,
        UserID         => 1,
    );
    push @ConfigItemIDList, $ConfigItemID;
    $Count++;

    ok(
        $ConfigItemID,
        "Added $Ord config item",
    );
}

# search CIs that belong to the 'admin' group and check the query result
my @ConfigItemResultList = $ConfigItemObject->ConfigItemSearch(
        Result       => 'ARRAY',
        OrderBy      => 'Up',
        ConfigItemID => \@ConfigItemIDList,
        GroupIDs     => [$FirstGroupID],
    );

ok(
    scalar @ConfigItemResultList == 3 
            && $ConfigItemResultList[0] == $ConfigItemIDList[0]
            && $ConfigItemResultList[1] == $ConfigItemIDList[1]
            && $ConfigItemResultList[2] == $ConfigItemIDList[4],
    "Search for config items of group $FirstGroupID"
);

# move the third CI from the 'stats' to the 'admin' group
my $Success = $ConfigItemObject->ConfigItemUpdate(
    ConfigItemID   => $ConfigItemIDList[2],
    GroupID        => $FirstGroupID,
    UserID         => 1,
);

ok(
    $Success,
    "Changed third config item",
);

# repeat the search and check the updated results
@ConfigItemResultList = $ConfigItemObject->ConfigItemSearch(
        Result       => 'ARRAY',
        OrderBy      => 'Up',
        ConfigItemID => \@ConfigItemIDList,
        GroupIDs     => [$FirstGroupID],
    );

ok(
    scalar @ConfigItemResultList == 4 
            && $ConfigItemResultList[0] == $ConfigItemIDList[0]
            && $ConfigItemResultList[1] == $ConfigItemIDList[1]
            && $ConfigItemResultList[2] == $ConfigItemIDList[2]
            && $ConfigItemResultList[3] == $ConfigItemIDList[4],
    "Search for config items of group '$GroupList{$FirstGroupID}' after update"
);

# delete the first three CIS which belong all to the 'admin' group
my $Index = 0;
for my $Ord (qw(first second third))
{
    my $Success = $ConfigItemObject->ConfigItemDelete(
        ConfigItemID  => $ConfigItemIDList[$Index++],
        UserID         => 1,
    );

    ok(
        $Success,
        "Deleted $Ord config item",
    );
}

# repeat the search and check the results after deletion
@ConfigItemResultList = $ConfigItemObject->ConfigItemSearch(
        Result       => 'ARRAY',
        OrderBy      => 'Up',
        ConfigItemID => \@ConfigItemIDList,
        GroupIDs     => [$FirstGroupID],
    );

ok(
    scalar @ConfigItemResultList == 1
            && $ConfigItemResultList[0] == $ConfigItemIDList[4],
    "Search for config items of group '$GroupList{$FirstGroupID}' after delete"
);

done_testing;
