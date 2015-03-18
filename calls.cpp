#include <iostream>

int main() {
    std::cout << "\ncalls(/)\n";
    for (unsigned i = 0; i < 0x31; ++i) 
        std::cout << "  *int_" << std::hex << i << "(/)\n";
    std::cout << "**\n";
    return 0;
}
