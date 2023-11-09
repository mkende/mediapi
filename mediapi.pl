use strict;
use warnings;

use utf8;

BEGIN {
    $ENV{DISPLAY} //= ':0';
}

use Tkx;
use X11::Protocol;

my ($screen_x, $screen_y);
{
    my $X = X11::Protocol->new();
    $screen_x = $X->{screens}[0]{width_in_pixels} // 320;
    $screen_y = $X->{screens}[0]{height_in_pixels} // 240;
}

open my $pigpio, '>', '/dev/pigpio';

my $wnd = Tkx::widget->new('.');

# fullscreen removes the border of the window but does not actually make it
# fullscreen (maybe because we don’t have a real window manager... which also
# means that we don’t have a border anyway).
$wnd->g_wm_attribute(-fullscreen => 1, -topmost => 1);
$wnd->g_wm_resizable(0, 0);
$wnd->configure(-cursor => 'none');
$wnd->g_wm_geometry("${screen_x}x${screen_y}");

my $media_control_frame = $wnd->new_ttk__frame(-borderwidth => 5); # The border is here only to debug
$media_control_frame->g_grid(-column => 0, -row => 0, -sticky => 'nswe');
$wnd->g_grid_columnconfigure(0, -weight => 1);
$wnd->g_grid_rowconfigure(0, -weight => 1);

# The default font does not have the media control glyphs. So let’s create a
# style using Unifont that has almost all glyphs.
# Useful link: https://en.wikipedia.org/wiki/Media_control_symbols
Tkx::ttk__style_configure('Unicode.TButton', -font => 'Unifont 15');

$media_control_frame->g_grid_columnconfigure(0, -weight => 1);
$media_control_frame->g_grid_columnconfigure(1, -weight => 1);
$media_control_frame->g_grid_rowconfigure(0, -weight => 1);
$media_control_frame->g_grid_rowconfigure(1, -weight => 1);

my $play_btn = $media_control_frame->new_ttk__button(-text => '⏵', -style => 'Unicode.TButton');
$play_btn->g_grid(-column => 0, -row => 0, -sticky => 'nswe', -padx => 10, -pady => 10);
my $pause_btn = $media_control_frame->new_ttk__button(-text => '⏸', -style => 'Unicode.TButton');
$pause_btn->g_grid(-column => 1, -row => 0, -sticky => 'nswe', -padx => 10, -pady => 10);
my $prev_btn = $media_control_frame->new_ttk__button(-text => '⏮', -style => 'Unicode.TButton');
$prev_btn->g_grid(-column => 0, -row => 1, -sticky => 'nswe', -padx => 10, -pady => 10);
my $next_btn = $media_control_frame->new_ttk__button(-text => '⏭', -style => 'Unicode.TButton');
$next_btn->g_grid(-column => 1, -row => 1, -sticky => 'nswe', -padx => 10, -pady => 10);

# This remove the focus and "active" decoration of the button when they are selected.
# We might want some kind of feedback that they were selected though.
Tkx::bind('TButton', '<FocusIn>', [sub { $wnd->g_focus(); Tkx::widget->new($_[0])->state('!active'); }, Tkx::Ev('%W')]);

# The commands are documented at https://abyz.me.uk/rpi/pigpio/pigs.html
syswrite $pigpio, "w 18 1\n";  # Switch on the backlight of the screen.

Tkx::MainLoop();
