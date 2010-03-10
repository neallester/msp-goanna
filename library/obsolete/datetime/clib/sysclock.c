/* sclock.c
 * Peter Webb, Feb. 1995
 *
 * C routines to enable ISE Eiffel to access the system clock.  See
 * system_clock.e.
 *
 */

#include <time.h>
#include <eif_eiffel.h>

EIF_INTEGER c_read_time()
{
   return time(0);
}

EIF_INTEGER c_getyear(t)
     EIF_POINTER t;
{
   return ( localtime((long*)t)->tm_year+1900 );
}

EIF_INTEGER c_getmonth(t)
     EIF_POINTER t;
{
   return (localtime((long*)t)->tm_mon+1);
}

EIF_INTEGER c_getday(t)
     EIF_POINTER t;
{
   return ( localtime((long*)t)->tm_mday );
}

EIF_INTEGER c_gethour(t)
     EIF_POINTER t;
{
   return ( localtime((long*)t)->tm_hour );
}

EIF_INTEGER c_getminute(t)
     EIF_POINTER t;
{
   return ( localtime((long*)t)->tm_min );
}

EIF_INTEGER c_getsecond(t)
     EIF_POINTER t;
{
   return ( localtime((long*)t)->tm_sec );
}
