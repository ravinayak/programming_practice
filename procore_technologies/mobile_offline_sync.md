Given that the mobile platform works offline, how would you prevent duplications from entering the system once items created offline are synced with backing system.

When designing a system that allows mobile platforms to work offline, preventing duplication when items created offline are later synced can be challenging. Here are some strategies to handle this:

1. Generate Unique Identifiers for Offline Records

Assign a unique identifier (UUID) to each item when it’s created offline. By using UUIDs or a similar unique identifier strategy, you ensure that each item is distinct, even when multiple users are creating records offline. When the offline items are synced, the backend can use these UUIDs to recognize new versus already-existing items.
• Implementation: When a user creates an item offline, generate a UUID (universally unique identifier) and attach it to the record. Once the device is online, send this UUID to the server along with other record details.
• Sync Logic: The backend system checks if an item with this UUID already exists. If it does, the server ignores it as a duplicate; if not, it’s saved as a new item.

2. Track Synced Items with Timestamps

Track the last sync timestamp for each device or user on the server. When the device goes online and syncs items, it can only upload items created or updated after the last sync timestamp.
• Implementation: Each item created offline includes a timestamp indicating when it was created or modified. When the device syncs, it only uploads items that were created or updated after the last recorded sync timestamp for that device.
• Sync Logic: The server checks for items created within the specified timeframe to avoid re-syncing duplicates. Additionally, if items are edited offline, timestamps can help ensure that newer versions overwrite older ones.

3. Use Checksum or Hashing to Detect Duplicate Content

Generate a hash or checksum of the item’s content (e.g., a combination of key attributes). When an item is created offline, generate a hash based on its content and store it with the item. When the device syncs, the server can check the hash to detect duplicates.
• Implementation: For each new or updated item, calculate a hash based on its content (e.g., name, description, and other key attributes). Include this hash in the sync payload.
• Sync Logic: The server verifies whether an item with the same hash already exists. If it does, it’s recognized as a duplicate and ignored; if not, it’s saved as a new item.

4. Mark Items with “Synced” Flags

Use a “synced” flag or status for items created offline. This flag indicates whether the item has already been synced with the backend system.
• Implementation: Items created offline are saved with a “synced” status set to false. Once the item is successfully synced, the server updates this status to true.
• Sync Logic: On the next sync attempt, only items with a “synced” status of false are sent to the server. This way, the device doesn’t attempt to re-sync items that have already been successfully uploaded.

5. Conflict Resolution Policies for Edge Cases

There are cases where two users may create identical records while offline. A conflict resolution policy can help the system decide which version to keep and which to discard.
• Implementation: When two identical records are detected, implement a rule that determines which record takes precedence. For example, the system could keep the record with the earlier timestamp or the one created by the first user to come online.
• Sync Logic: The server detects duplicates based on the unique identifier, hash, or timestamp and applies the conflict resolution policy.

Combining Strategies for Robustness

In practice, combining strategies can help increase the reliability of offline sync and duplication prevention. For example:
• Use UUIDs to uniquely identify items, so each offline-created item is distinguishable.
• Use timestamps to track when each item was created or last modified.
• Add a hash to detect content-based duplicates in case users create items with the same attributes.

This multi-layered approach can help ensure that your system effectively prevents duplicates, even under complex offline conditions.
