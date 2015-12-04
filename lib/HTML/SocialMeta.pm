package HTML::SocialMeta;
use Moose;
use namespace::autoclean;

use HTML::SocialMeta::Twitter;
use HTML::SocialMeta::OpenGraph;
use HTML::SocialMeta::Schema;

=head1 NAME

HTML::SocialMeta - Module to generate Social Media Meta Tags, 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.1';

=head1 DESCRIPTION

This module makes it easy to create social meta cards.

i.e  $social->create(card => 'summary') will generate:
	
	<html itemscope itemtype="http://schema.org/Article">
	<title>You can have any title you wish here</title>
	<meta name="description" content="Description goes here may have to do a little validation">
	<meta itemprop="name" content="You can have any title you wish here"/>
	<meta itemprop="description" content="Description goes here may have to do a little validation"/>
	<meta itemprop="image" content="www.urltoimage.com/blah.jpg"/>
	<meta name="twitter:card" content="summary"/>
	<meta name="twitter:site" content="@example_twitter"/>
	<meta name="twitter:title" content="You can have any title you wish here"/>
	<meta name="twitter:description" content="Description goes here may have to do a little validation"/>
	<meta name="twitter:image" content="www.urltoimage.com/blah.jpg"/>
	<meta property="og:type" content="thumbnail"/>
	<meta property="og:title" content="You can have any title you wish here"/>
	<meta property="og:description" content="Description goes here may have to do a little validation"/>
	<meta property="og:url" content="www.someurl.com"/>
	<meta property="og:image" content="www.urltoimage.com/blah.jpg"/>
	<meta property="og:site_name" content="Example Site, anything"/>

It allows you to optimize sharing on several social media platforms such as Twitter, Facebook, Google+ 
and Pinerest by defining exactly how titles, descriptions, images and more appear in social streams.

It generates all the required META data that is needed to create social cards for the following Providers:

	* Twitter
	* OpenGraph
	* Schema.org

These are then supported on the following sites, just to name a few

    * Facebook
    * LinkedIn
    * Reddit
    * Pinerest
    * Twitter

This module currently only supports the following card types, it will expand over time

	* summary - thumbnail image on the left hand side, with title and description on the right 
	* featured_image - full featured image with text underneath
	* app - App Card

=head1 SYNOPSIS

    use HTML::SocialMeta;

    my $social = HTML::SocialCards->new(
        card_type => '...',
    	site => '',
    	title => '',
    	description => '',
    	image	=> ''
    );

	# returns meta tags for all providers	
	my $meta_tags = $social->create;

	# returns meta tags specificly for a single provider
	my $twitter_tags = $social->twitter;
	my $opengraph_tags = $social->pengraph;
	my $schema = $social->create->schema

	# You then need to insert these meta tags in the head of your html, 
	# one way of implementing this if you are using Catalyst and Template Toolkit would be ..
	# controller 
	$c->stash->{meta_tags} = $meta_tags;
	# template
	[% meta_tags | html %]

=head1 METHODS

=head2 new

Returns an instance of this class. Requires C<$url> as an argument;

    my $social = URL::Social->new(
        card => '...',  	* card type - currently either summary or featured_image
        site => '',	 		* twitter site - @twitter_handle 
        site_name => '',	* sites name - Example Business
        title => '',		* card title - title of the card 
        description => '',	* description - content of the card
        image => '',		* attached image - url http/www.someurl.com/test.jpg
        url => '',			* url where the content is hosted, or url to some completly randon html page
        ... => '',
        ... => '',
    );

,-----------------------------------,
|   TITLE                 *-------* |
|                         |       | |
|   DESCRIPTION           |       | |
|                         *-------* |
*-----------------------------------*

Summary Card:

   card => 'summary'

or

   my $twitter_summary_card = $social->twitter->create_summary_card;
   my $opengraph_thumbnail_card = $social->opengraph->create_thumbnail_card;
   my $schema_tags = $social->schema->create_card;

fields required:

* card   
* site_name - OpenGraph
* site - Twitter Site
* title
* description
* image

,-----------------------------------,
| *-------------------------------* |
| |                               | |
| |                               | |
| |                               | |
| |                               | |
| |                               | |
| |                               | |
| *-------------------------------* |
|  TITLE                            |
|  DESCRIPTION                      |
*-----------------------------------*

Featured Image Card:

	card => 'featured_image' 

or

	my $twitter_featured_image_card = $social->twitter->create_featured_image_card;
	my $opengraph_article_card = $meta_tags->opengraph->create_article_card;

Fields Required:

* card - Twitter
* site - Twitter
* site_name  - Open Graph
* creator - Twitter
* title
* image
* url - Open Graph

,-----------------------------------,
|   APP NAME              *-------* |
|   APP INFO              |  app  | |
|                         | image | |
|   PRICE                 *-------* |
|   DESCRIPTION                     |
*-----------------------------------*
App Card:

	my $twitter_app_card = $social->twitter->create_app_card;

Fields Required
* card
* site
* description
* app_country
* app_name_store
* app_id_store
* app_url_store
* app_id_play
* app_id_play
* app_id_play

price and app info pulled from the app stores?

=cut

has 'card_type' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'card' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'site' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'site_name' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'title' => ( isa => 'Str',  is => 'ro',  lazy => 1, default => '' );
has 'description' => ( isa => 'Str',  is => 'ro',  lazy => 1, default => '' );
has 'image' => ( isa => 'Str',  is => 'ro',  lazy => 1, default => '' );
has 'url' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'creator' => ( isa => 'Str',  is => 'ro',  lazy => 1, default => '' );
has 'app_country' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_name_store' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_id_store' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_url_store' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_name_play' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_id_play' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );
has 'app_url_play' => ( isa => 'Str',  is => 'ro', lazy => 1, default => '' );

has 'twitter' => ( isa => 'HTML::SocialMeta::Twitter', is => 'ro', lazy => 1, builder => '_build_twitter');
has 'opengraph' => ( isa => 'HTML::SocialMeta::OpenGraph', is => 'ro', lazy => 1, builder => '_build_opengraph' );
has 'schema' => ( isa => 'HTML::SocialMeta::Schema', is => 'ro', lazy_build => 1, builder => '_build_schema' );

=head2 create

Create the Meta Tags - this returns the meta information for all the providers:
	
	* Twitter
	* OpenGraph
	* Google
	
You just need to specify the card type on create

	$social->create(card => 'summary | feature_image')

=cut

sub create {
	my ($self, $card_type) = @_;
	
	$card_type = $card_type || $self->card_type;

	my @meta_tags =  map { $self->$_->create() } qw/schema twitter opengraph/;
	
	return join("\n", @meta_tags); 
}

sub _build_twitter{
	my $self = shift;
  
  	my $twitter = HTML::SocialMeta::Twitter->new( 
    	card => $self->card,
    	site => $self->site,
    	title => $self->title,
    	description => $self->description,
    	image => $self->image, 
    	url => $self->url, 
    	creator => $self->creator,  
    	app_country => $self->app_country,
    	app_name_store => $self->app_name_store,
    	app_id_store => $self->app_id_store,
    	app_url_store => $self->app_url_store,
    	app_name_play => $self->app_name_play,
    	app_id_play => $self->app_id_play,
    	app_url_play => $self->app_url_play,
    );
};


sub _build_opengraph{
    my $self = shift;

    my $open_graph = HTML::SocialMeta::OpenGraph->new( 
    	type => $self->card,
    	site_name => $self->site_name,
    	title => $self->title,
    	description => $self->description,
    	image => $self->image, 
    	url => $self->url, 
    );
}

sub _build_schema {
	my $self = shift;

	my $google = HTML::SocialMeta::Schema->new(
		name => $self->title,
		description => $self->description,
		image => $self->image,
	);
}

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHORS

Robert Acock <ThisUsedToBeAnEmail@gmail.com>

=head1 TODO
 
    * Improve tests
    * Add support for more social Card Types / Meta Providers
 
=head1 BUGS
 
Most probably. Please report any bugs at http://rt.cpan.org/.
 
=head1 LICENSE AND COPYRIGHT
 
Copyright 2013-2014 Tore Aursand.
 
This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:
 
L<http://www.perlfoundation.org/artistic_license_2_0>
 
Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.
 
If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.
 
This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.
 
This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.
 
Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

