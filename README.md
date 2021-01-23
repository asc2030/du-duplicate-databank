# du-duplicate-databank
Duplicate a databank in DU with key check and overwrite confirmation

## Usage
1. Set up a programming board and connect the databanks, source first and then target.

2. Paste the conf file contents to the programming board using the context menu.

3. Activate the board, it will output a report in the Lua text chanell that needs to be actioned.

## Actions
Nothing will be copied until text is entered confirming what action should be taken following the report.

### Confirm
Typing "confirm" will copy over all keys that don't already exist on the target databank only.

### Confirm Overwrite
Typing "confirm overwrite" will copy over all keys and overwrite any existing data.