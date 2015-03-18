#include <iostream>

int main() {
    std::cout << "\nint_list(L1/)\n";
    for (unsigned i = 0; i < 0x31; ++i)
        std::cout << "    [int_" << std::hex << i << "]⇒L1." << std::dec << i << "\n";
    std::cout<<"**\n";
    for (unsigned i = 0; i < 0x31; ++i)
        std::cout << "\nint_" << std::hex << i << "(/)\n    @+F1(64)\n    @\'Int 0x" << std::hex << i << "\'>F1\n    10@>F1\n    *print(F1/)\n    @-F1\n    iret\n    **\n";
    return 0;
}
