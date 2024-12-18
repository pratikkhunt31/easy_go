import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'account': 'Account',
          'personalInfo': 'Personal Info',
          'settings': 'Settings',
          'yourBookings': 'Your Bookings',
          'privacyPolicy': 'Privacy Policy',
          'helpSupport': 'Help & Support',
          'lang': 'Language',
          'logOut': 'Log Out',
          'appVersion': 'App Version',
          'home': 'Home',
          'bookings': 'Bookings',
          'profile': 'Profile',
          'welcomeMessage': 'Welcome to, Easy Go',
          'currentLocation': 'Your Current Location',
          'lookingParcelDeliver': 'Are you looking for Parcel Delivery?',
          'bookYourDelivery': 'Book for your delivery',
          'atulShakti': 'Atul Shakti',
          'chotaHathi': 'Chhota Hathi',
          'suzuki': 'Suzuki Pickup',
          'bolero': 'Bolero',
          'eTempo': 'e-Tempo',
          'rickshaw': 'Auto Rickshaw',
          'eRickshaw': 'e-Rickshaw',
          'eicher': 'Eicher',
          'pending': 'Pending',
          'complete': 'Complete',
          'cancel': 'Cancel',
          'pickUpDetails': 'PickUp Details',
          'receiverDetails': 'Drop off Details',
          'userCurrentLocation': 'Use Current Location',
          'locateMap': 'Locate on Map',
          'name': 'Name',
          'mobile': 'Mobile Number',
          'goodsType': 'Enter Goods Type',
          'firstFloorLoad': 'For loading from 1st floor and above',
          'continue': 'Continue',
          'location': 'Location',
          'receiveReceiveOTP':
              'Receiver wil receive OTP on this number to verify',
          'rideDetails': 'Ride Details',
          'summary': 'Fare Summary',
          'distance': 'Total Distance',
          'tripFare': 'Trip Fare (incl. Toll)',
          'netFare': 'Net Fare',
          'amountToPay': 'Amount Payable (rounded)',
          'goods': 'Goods',
          'confirmRide': 'Confirm Ride',
          'cancelRide': 'Cancel Ride',
          'timeRemain': 'Time remaining',
          'findingADriver': 'Finding a driver...',
          'driverDetails': 'Driver Details',
          'proceedToPayment': 'Proceed to Payment',
          'driver': 'Driver',
          'driverNotAssign': 'Driver not assigned. Please make a new request.',
          'rideCancelSuccess': 'Ride cancelled successfully',
        },
        'gu_IN': {
          'account': 'એકાઉન્ટ',
          'personalInfo': 'વ્યક્તિગત માહિતી',
          'settings': 'સેટિંગ્સ',
          'yourBookings': 'તમારી બુકિંગ',
          'privacyPolicy': 'ગોપનીયતા નીતિ',
          'helpSupport': 'મદદ અને આધાર',
          'lang': 'ભાષા',
          'logOut': 'લોગ આઉટ કરો',
          'appVersion': 'એપ્લિકેશન સંસ્કરણ',
          'home': 'ઘર',
          'bookings': 'બુકિંગ',
          'profile': 'પ્રોફાઇલ',
          'welcomeMessage': 'Easy Go માં આપનું સ્વાગત છે',
          'currentLocation': 'તમારું વર્તમાન સ્થાન',
          'lookingParcelDeliver': 'શું તમે પાર્સલ ડિલિવરી શોધી રહ્યાં છો?',
          'bookYourDelivery': 'તમારી ડિલિવરી માટે બુક કરો',
          'atulShakti': 'અતુલ શક્તિ',
          'chotaHathi': 'છોટા હાથી',
          'suzuki': 'સુઝુકી પિકઅપ',
          'bolero': 'બોલેરો',
          'eTempo': 'ઇ-ટેમ્પો',
          'rickshaw': 'ઓટો રીક્ષા',
          'eRickshaw': 'ઈ-રિક્ષા',
          'eicher': 'આઈશર',
          'pending': 'બાકી છે',
          'complete': 'પૂર્ણ',
          'cancel': 'રદ કરો',
          'pickUpDetails': 'મોકલનાર વિગતો',
          'receiverDetails': 'પ્રાપ્તકર્તા વિગતો',
          'userCurrentLocation': 'વર્તમાન સ્થાનનો ઉપયોગ કરો',
          'locateMap': 'નકશા પર સ્થિત કરો',
          'name': 'નામ',
          'mobile': 'મોબાઈલ નંબર',
          'goodsType': 'માલનો પ્રકાર દાખલ કરો',
          'firstFloorLoad': '1 માળ અને ઉપરથી લોડ કરવા માટે',
          'continue': 'ચાલુ રાખો',
          'location': 'સ્થાન',
          'receiveReceiveOTP': 'પ્રાપ્તકર્તાને આ નંબર પર OTP પ્રાપ્ત થશે ',
          'rideDetails': 'રાઇડ વિગતો',
          'summary': 'ભાડું સારાંશ',
          'distance': 'કુલ અંતર',
          'tripFare': 'ટ્રીપનું ભાડું (ટોલ સહિત)',
          'netFare': 'નેટ ભાડું',
          'amountToPay': 'ચૂકવવાપાત્ર રકમ (ગોળાકાર)',
          'goods': 'માલ',
          'confirmRide': 'રાઇડની પુષ્ટિ કરો',
          'cancelRide': 'રાઈડ રદ કરો',
          'timeRemain': 'બાકીનો સમય',
          'findingADriver': 'ડ્રાઇવરને શોધી રહ્યાં છીએ...',
          'driverDetails': 'ડ્રાઇવરની વિગતો',
          'proceedToPayment': 'ચુકવણી પર આગળ વધો',
          'driver': 'ડ્રાઈવર',
          'driverNotAssign': 'ડ્રાઇવરને સોંપેલ નથી. કૃપા કરીને નવી વિનંતી કરો.',
          'rideCancelSuccess': 'સવારી રદ કરો',
        }
      };
}
