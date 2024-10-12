# test_gtk.py
import gtk

window = gtk.Window()
window.set_title("Test GTK")
window.connect("destroy", gtk.main_quit)
window.show_all()
gtk.main()