
import matplotlib.pyplot as plt
import numpy as np

# 1. Load your software reference matrix (100x100) and VHDL hardware output (100x100)
G_python = np.loadtxt("python_ref.txt")  # or cv2.imread("python_out.png", 0)
G_vhdl = np.loadtxt("SobelEdgeVHDL.txt").reshape(98,98)

# 2. Compute the Absolute Error Matrix D(i, j)
D = np.abs(G_python.astype(np.float32) - G_vhdl.astype(np.float32))

# 3. Compute MAE across the 100x100 frame
total_error = np.sum(D)
mae = total_error / 10000.0

print(f"Total Frame Error: {total_error}")
print(f"Mean Absolute Error (MAE): {mae:.4f}")

# 4. Generate and plot the Difference Heatmap
plt.figure(figsize=(6, 5))
plt.imshow(D, cmap="hot")
plt.colorbar(label="Absolute Difference (Intensity)")
plt.title(f"Sobel Error Heatmap (MAE = {mae:.2f})")
plt.xlabel("Column (j)")
plt.ylabel("Row (i)")
plt.tight_layout()

plt.savefig("sobel_error_heatmap.png", dpi=300, bbox_inches="tight")