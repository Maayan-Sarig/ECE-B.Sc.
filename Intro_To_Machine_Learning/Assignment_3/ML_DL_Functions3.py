import torch
import torch.nn as nn
import torch.nn.functional as F


# --------------------------------------------------
# Single-image CNN
# Input:  (N, 3, 448, 224)
# Output: (N, 2)
# --------------------------------------------------
class CNN(nn.Module):
    def __init__(self):  # Do NOT change the signature
        super(CNN, self).__init__()

        n = 32
        kernel_size = 5
        padding = (kernel_size - 1) // 2

        self.pool = nn.MaxPool2d(2, 2)

        self.conv1 = nn.Conv2d(3, n, kernel_size, padding=padding)
        self.gn1   = nn.GroupNorm(8, n)

        self.conv2 = nn.Conv2d(n, 2*n, kernel_size, padding=padding)
        self.gn2   = nn.GroupNorm(8, 2*n)

        self.conv3 = nn.Conv2d(2*n, 4*n, kernel_size, padding=padding)
        self.gn3   = nn.GroupNorm(16, 4*n)

        self.conv4 = nn.Conv2d(4*n, 8*n, kernel_size, padding=padding)
        self.gn4   = nn.GroupNorm(32, 8*n)

        # 448x224 -> 224x112 -> 112x56 -> 56x28 -> 28x14
        self.fc1 = nn.Linear(8 * n * 28 * 14, 100)
        self.fc2 = nn.Linear(100, 2)

        self.relu = nn.ReLU()

        self.drop = nn.Dropout(0.1)

    def forward(self, inp):  # Do NOT change the signature
        out = self.pool(self.relu(self.gn1(self.conv1(inp))))
        out = self.pool(self.relu(self.gn2(self.conv2(out))))
        out = self.pool(self.relu(self.gn3(self.conv3(out))))
        out = self.pool(self.relu(self.gn4(self.conv4(out))))

        out = torch.flatten(out, start_dim=1)
        out = self.relu(self.fc1(out))
        out = self.drop(out)
        out = self.fc2(out)

        return out


# --------------------------------------------------
# Channel-wise CNN (pair concatenation)
# Input:  (N, 3, 448, 224)
# Output: (N, 2)
# --------------------------------------------------
class CNNChannel(nn.Module):
    def __init__(self):  # Do NOT change the signature
        super(CNNChannel, self).__init__()

        n = 24
        kernel_size = 5
        padding = (kernel_size - 1) // 2

        self.pool = nn.MaxPool2d(2, 2)

        self.conv1 = nn.Conv2d(6, n, kernel_size, padding=padding)
        self.gn1   = nn.GroupNorm(8, n)

        self.conv2 = nn.Conv2d(n, 2*n, kernel_size, padding=padding)
        self.gn2   = nn.GroupNorm(8, 2*n)

        self.conv3 = nn.Conv2d(2*n, 4*n, kernel_size, padding=padding)
        self.gn3   = nn.GroupNorm(16, 4*n)

        self.conv4 = nn.Conv2d(4*n, 8*n, kernel_size, padding=padding)
        self.gn4   = nn.GroupNorm(32, 8*n)

        # 224x224 -> 112x112 -> 56x56 -> 28x28 -> 14x14
        self.fc1 = nn.Linear(8 * n * 14 * 14, 100)
        self.fc2 = nn.Linear(100, 2)

        self.drop = nn.Dropout(0.1)

    def forward(self, inp):  # Do NOT change the signature
        # Split image pair and concatenate along channels
        img1 = inp[:, :, :224, :]
        img2 = inp[:, :, 224:, :]
        out = torch.cat([img1, img2], dim=1)  # (N, 6, 224, 224)

        out = self.pool(F.relu(self.gn1(self.conv1(out))))
        out = self.pool(F.relu(self.gn2(self.conv2(out))))
        out = self.pool(F.relu(self.gn3(self.conv3(out))))
        out = self.pool(F.relu(self.gn4(self.conv4(out))))

        out = torch.flatten(out, start_dim=1)
        out = F.relu(self.fc1(out))
        out = self.drop(out)
        out = self.fc2(out)

        return out
