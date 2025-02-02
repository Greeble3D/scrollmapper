import os

# Define the directories
base_dir = "scroll_sprites"
size_dirs = ["32", "64", "128"]
reference_dir = "256"

# Get the list of PNG files in the reference directory
reference_dir_path = os.path.join(base_dir, reference_dir)
if os.path.exists(reference_dir_path):
    reference_files = set(os.listdir(reference_dir_path))
else:
    print(f"Reference directory {reference_dir_path} does not exist.")
    reference_files = set()

# Loop through the size directories
for size_dir in size_dirs:
    size_dir_path = os.path.join(base_dir, size_dir)
    if os.path.exists(size_dir_path):
        for file_name in os.listdir(size_dir_path):
            if file_name.endswith(".png"):
                # Check if the file exists in the reference directory
                if file_name not in reference_files:
                    # Delete the file if it does not exist in the reference directory
                    file_path = os.path.join(size_dir_path, file_name)
                    os.remove(file_path)
                    print(f"Deleted {file_path}")
    else:
        print(f"Size directory {size_dir_path} does not exist.")

print("Cleanup complete.")