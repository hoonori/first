#include"ExtendableArray.h"

ElementRef::ElementRef( ExtendableArray& theArray, int i )
: index(i)
{
    intArrayRef = &theArray;
}

ElementRef::ElementRef( const ElementRef& other ) // copy constructor
: index(other.index), intArrayRef(other.intArrayRef)
{
}

ElementRef::~ElementRef()
{
    
}

ElementRef& ElementRef::operator=( const ElementRef& rhs )
{
    if (index < intArrayRef->size){
        intArrayRef->arrayPointer[index] = rhs;
    }
    else{
        int* newarr = new int[index+1];
        for (int i = 0; i < index; i++){
            if (i < intArrayRef->size){
                newarr[i] = intArrayRef->arrayPointer[i];
            }
            else{
                newarr[i] = 0;
            }
        }
        newarr[index] = int(rhs);
        
        delete[] intArrayRef->arrayPointer;
        intArrayRef->size = index+1;
        intArrayRef-> arrayPointer = newarr;
    }
    return *this;
}

ElementRef& ElementRef::operator=( int val )
{
    if (index < intArrayRef->size){
        intArrayRef->arrayPointer[index] = val;
    }
    else{
        int* newarr = new int[index+1];
        for (int i = 0; i < index; i++){
            if (i < intArrayRef->size){
                newarr[i] = intArrayRef->arrayPointer[i];
            }
            else{
                newarr[i] = 0;
            }
        }
        newarr[index] = val;
        
        delete[] intArrayRef->arrayPointer;
        intArrayRef->size = index+1;
        intArrayRef-> arrayPointer = newarr;
    }
    return *this;
}

ElementRef::operator int() const
{
    if (index < intArrayRef->size){
        return intArrayRef->arrayPointer[index];
    }
    return 0;
}

ExtendableArray::ExtendableArray() //allocates memory space for 2 integers
: size(2)
{
    arrayPointer = new int[2];
    arrayPointer[0] = 0; arrayPointer[1] = 0;
}


ExtendableArray::ExtendableArray( const ExtendableArray& other ) // copy constructor
: size(other.size)
{
    delete arrayPointer;
    
    arrayPointer = new int[size];
    for (int i = 0; i < size; i++){
        arrayPointer[i] = other.arrayPointer[i];
    }
}

ExtendableArray::~ExtendableArray() // destructor
{
    delete[] arrayPointer;
}

ExtendableArray& ExtendableArray::operator=( const ExtendableArray& rhs )
{
    delete arrayPointer;
    size = rhs.size;
    
    arrayPointer = new int[size];
    for (int i = 0; i < size; i++){
        arrayPointer[i] = rhs.arrayPointer[i];
    }
    
    return *this;
}

ElementRef ExtendableArray::operator[]( int i )
{
    return ElementRef(*this, i);
}
