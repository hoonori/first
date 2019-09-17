//
// Expandable integer array class //
#ifndef EARRAY_H
#define EARRAY_H
#include <ostream>
using namespace std;
class ExtendableArray;
class ElementRef
{
private:
    ExtendableArray *intArrayRef; //pointer to the array
    int index; // index of this element
public:
    ElementRef( ExtendableArray& theArray, int i );
    ElementRef( const ElementRef& other ); // copy constructor
    ~ElementRef();
    ElementRef& operator=( const ElementRef& rhs );
    ElementRef& operator=( int val );
    operator int() const;
};
class ExtendableArray {
private:
    int *arrayPointer; // integer array pointer
    int size; // the size of array
public:
    ExtendableArray(); //allocates memory space for 2 integers
    ExtendableArray( const ExtendableArray& other ); // copy constructor
    ~ExtendableArray(); // destructor
    ExtendableArray& operator=( const ExtendableArray& rhs );
    ElementRef operator[]( int i );
    friend class ElementRef; // ElementRef class can access my private members
    friend ostream& operator<< (ostream& o, const ExtendableArray& t){
        for(int i=0;i<t.size;i++){
            o << t.arrayPointer[i] << " ";
        }
        return o; }
};
#endif // EARRAY_H
