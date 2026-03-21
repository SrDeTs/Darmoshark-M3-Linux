#pragma once

#include <cstdint>
#include <vector>
#include <QString>
#include <QStringList>

namespace DarmosharkProtocol {

// Device Identifiers
const uint16_t DARMOSHARK_VID = 0x248A;
const uint16_t M3_USB_PID = 0xFF12;
const uint16_t M3_24G_PID = 0xFF30;
const uint16_t M3_24G_G_PID = 0xFF31;

// Helper to calculate XOR checksum and finalize packet
void finalizePacket(std::vector<uint8_t>& packet) {
    if (packet.size() < 65) return;
    
    uint8_t checksum = 0;
    for (size_t i = 1; i < 64; ++i) { // Calculate checksum from byte 1 to 63
        checksum ^= packet[i];
    }
    packet[64] = checksum;
}

// DPI Feature Report captured from the Windows driver.
std::vector<uint8_t> createDpiPacket(const QStringList& stages, int current_stage, bool wiredMode) {
    std::vector<uint8_t> packet(21, 0x00);
    packet[0] = 0x51;
    packet[1] = 0x40;
    if (wiredMode) {
        packet[2] = static_cast<uint8_t>(current_stage);
        packet[3] = 0xff;
    } else {
        packet[2] = 0xff;
        packet[3] = static_cast<uint8_t>(current_stage);
    }
    packet[4] = 0xff;
    
    for (int i = 0; i < stages.size() && i < 7; ++i) {
        int dpi = stages[i].toInt(); // Raw DPI value (Little Endian)
        packet[5 + i*2] = dpi & 0xFF;
        packet[6 + i*2] = (dpi >> 8) & 0xFF;
    }
    packet[15] = static_cast<uint8_t>(stages.size());
    return packet;
}

// Polling Rate Feature Report captured from the Windows driver.
std::vector<uint8_t> createPollingRatePacket(int pollingRate, bool wiredMode) {
    std::vector<uint8_t> packet(21, 0x00);
    packet[0] = 0x51;
    packet[1] = 0x41;
    packet[2] = 0xff;

    // Captured order from the original driver:
    // 125Hz: 0, 500Hz: 1, 1000Hz: 2
    uint8_t prIdx = 2;
    if (pollingRate == 125) prIdx = 0;
    else if (pollingRate == 500) prIdx = 1;

    if (wiredMode) {
        packet[2] = prIdx;
        packet[3] = 0xff;
    } else {
        packet[2] = 0xff;
        packet[3] = prIdx;
    }
    packet[4] = 0xff;
    packet[5] = 0x7d; packet[6] = 0x00;
    packet[7] = 0xf4; packet[8] = 0x01;
    packet[9] = 0xe8; packet[10] = 0x03;
    return packet;
}

// Motion Sync packet captured from the Windows driver.
std::vector<uint8_t> createMotionSyncPacket(bool enabled, bool wiredMode) {
    if (wiredMode) {
        std::vector<uint8_t> packet(13, 0x00);
        packet[0] = 0x09;
        packet[1] = 0x00;
        packet[2] = 0x00;
        packet[3] = 0x01;
        packet[4] = 0x00;
        packet[5] = 0x02;
        packet[6] = 0x00;
        packet[7] = enabled ? 0x82 : 0x84;
        packet[8] = 0x01;
        return packet;
    }

    std::vector<uint8_t> packet(21, 0x00);
    packet[0] = 0x09;
    packet[1] = 0x00;
    packet[2] = 0x01;
    packet[3] = 0x02;
    packet[4] = 0x00;
    packet[5] = 0x03;
    packet[6] = 0x00;
    packet[7] = 0x82;
    packet[8] = 0x01;
    packet[9] = 0x08;
    packet[13] = 0x03;
    packet[17] = enabled ? 0x01 : 0x00;
    return packet;
}

// Angle Snap packet captured from the Windows driver.
std::vector<uint8_t> createAngleSnapPacket(bool enabled, bool wiredMode) {
    std::vector<uint8_t> packet(14, 0x00);
    packet[0] = 0x82;
    packet[1] = 0x01;
    packet[2] = 0x08;
    packet[3] = 0x00;
    packet[4] = 0x00;
    packet[5] = 0x00;
    packet[6] = wiredMode ? 0x01 : 0x03;
    packet[7] = 0x00;
    packet[8] = 0x00;
    packet[9] = 0x00;
    packet[10] = enabled ? 0x01 : 0x00;
    packet[11] = 0x00;
    packet[12] = 0x00;
    packet[13] = 0x00;
    return packet;
}

// Ripple Control packet captured from the Windows driver.
// The capture shows a simple enabled/disabled toggle.
std::vector<uint8_t> createRipplePacket(bool enabled, bool wiredMode) {
    std::vector<uint8_t> packet(14, 0x00);
    packet[0] = 0x82;
    packet[1] = 0x01;
    packet[2] = 0x08;
    packet[3] = 0x00;
    packet[4] = 0x00;
    packet[5] = 0x00;
    packet[6] = wiredMode ? 0x01 : 0x03;
    packet[7] = 0x00;
    packet[8] = enabled ? 0x00 : 0x01;
    packet[9] = 0x00;
    packet[10] = enabled ? 0xff : 0x00;
    packet[11] = enabled ? 0xff : 0x00;
    packet[12] = 0x00;
    packet[13] = 0x00;
    return packet;
}

// Lift Off Distance packet captured from the Windows driver.
// Low = 1 mm, High = 2 mm.
std::vector<uint8_t> createLiftOffDistancePacket(bool low) {
    std::vector<uint8_t> packet(14, 0x00);
    packet[0] = 0x82;
    packet[1] = 0x01;
    packet[2] = 0x08;
    packet[3] = 0x00;
    packet[4] = 0x00;
    packet[5] = 0x00;
    packet[6] = 0x03;
    packet[7] = 0x00;
    packet[8] = low ? 0x01 : 0x00;
    packet[9] = 0x00;
    packet[10] = low ? 0x00 : 0xff;
    packet[11] = low ? 0x00 : 0xff;
    packet[12] = 0x00;
    packet[13] = 0x00;
    return packet;
}

// Scroll Direction packet captured from the Windows driver.
// Forward = normal scrolling, Reverse = inverted scrolling.
std::vector<uint8_t> createScrollDirectionPacket(bool forward, bool wiredMode) {
    std::vector<uint8_t> packet(14, 0x00);
    packet[0] = 0x82;
    packet[1] = 0x01;
    packet[2] = 0x08;
    packet[3] = 0x00;
    packet[4] = 0x00;
    packet[5] = 0x00;
    packet[6] = wiredMode ? 0x01 : 0x03;
    packet[7] = 0x00;

    if (wiredMode) {
        packet[8] = forward ? 0x01 : 0x02;
        packet[9] = 0x00;
        packet[10] = 0x00;
    } else {
        packet[8] = forward ? 0x00 : 0x01;
        packet[9] = 0x00;
        packet[10] = forward ? 0x01 : 0x00;
    }

    packet[11] = 0x00;
    packet[12] = 0x00;
    packet[13] = 0x00;
    return packet;
}

// E-Sports Mode packet captured from the Windows driver.
// Open = faster response mode, Close = default mode.
std::vector<uint8_t> createESportsModePacket(bool open, bool wiredMode) {
    std::vector<uint8_t> packet(14, 0x00);
    packet[0] = 0x82;
    packet[1] = 0x01;
    packet[2] = 0x08;
    packet[3] = 0x00;
    packet[4] = 0x00;
    packet[5] = 0x00;
    packet[6] = wiredMode ? 0x01 : 0x03;
    packet[7] = 0x00;

    if (wiredMode) {
        packet[8] = open ? 0x01 : 0x00;
        packet[9] = 0x00;
        packet[10] = open ? 0x00 : 0xff;
        packet[11] = open ? 0x00 : 0xff;
    } else {
        packet[8] = open ? 0x00 : 0x01;
        packet[9] = 0x00;
        packet[10] = open ? 0x01 : 0x00;
        packet[11] = 0x00;
    }

    packet[12] = 0x00;
    packet[13] = 0x00;
    return packet;
}

} // namespace DarmosharkProtocol
