use strict;
use warnings;

use utf8;

BEGIN {
    $ENV{DISPLAY} //= ':0';
}

use Tkx;

my $wnd = Tkx::widget->new('.');

# fullscreen removes the border of the window but does not actually make it
# fullscreen (maybe because we don’t have a real window manager... which also
# means that we don’t have a border anyway).
$wnd->g_wm_attribute(-fullscreen => 1, -topmost => 1);
$wnd->g_wm_resizable(0, 0);
$wnd->configure(-cursor => 'none');
$wnd->g_wm_geometry('320x240');

my $media_control_frame = $wnd->new_ttk__frame(-borderwidth => 5); # The border is here only to debug
$media_control_frame->g_grid(-column => 0, -row => 0, -sticky => 'nswe');
$wnd->g_grid_columnconfigure(0, -weight => 1);
$wnd->g_grid_rowconfigure(0, -weight => 1);

# The default font does not have the media control glyphs. So let’s create a
# style using Unifont that has almost all glyphs.
# Useful link: https://en.wikipedia.org/wiki/Media_control_symbols
Tkx::ttk__style_configure('Unicode.TButton', -font => 'Unifont 15');

$media_control_frame->g_grid_columnconfigure(0, -weight => 1, -pad => 20);
$media_control_frame->g_grid_columnconfigure(1, -weight => 1, -pad => 20);
$media_control_frame->g_grid_rowconfigure(0, -weight => 1, -pad => 20);
$media_control_frame->g_grid_rowconfigure(1, -weight => 1, -pad => 20);

my $play_btn = $media_control_frame->new_ttk__button(-text => '⏵', -style => 'Unicode.TButton');
$play_btn->g_grid(-column => 0, -row => 0, -sticky => 'nswe');
my $pause_btn = $media_control_frame->new_ttk__button(-text => '⏸', -style => 'Unicode.TButton');
$pause_btn->g_grid(-column => 1, -row => 0, -sticky => 'nswe');
my $prev_btn = $media_control_frame->new_ttk__button(-text => '⏮', -style => 'Unicode.TButton');
$prev_btn->g_grid(-column => 0, -row => 1, -sticky => 'nswe');
my $next_btn = $media_control_frame->new_ttk__button(-text => '⏭', -style => 'Unicode.TButton');
$next_btn->g_grid(-column => 1, -row => 1, -sticky => 'nswe');

Tkx::update();
print "Current window geometry: ".$wnd->g_winfo_geometry()."\n";

Tkx::MainLoop();
