# Checklist Tracker App Files
"main.dart" contains the code for the main list screen and for creating/saving/loading/deleting list data.
"edit_info_screen.dart" contains the code for the second screen, which is used to edit the settings of an individual item, save or cancel the changes, or delete the item.
The main screen can access the edit screen through the "+ New" button at the bottom of the screen and the "edit" button on each of the existing items. The edit screen can return to the main screen through the "<-" button at the top left of the screen, the check mark ("save") button at the top right, or the "delete item" button at the bottom.
"item_data.dart" contains the ChecklistItem class, its variable definitions and initializations, and its constructor. This is used by both screens to create and edit individual list items and to edit the items' variable values.
