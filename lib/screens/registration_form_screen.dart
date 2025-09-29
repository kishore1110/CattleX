import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';
import '../services/animal_data_service.dart';

class RegistrationFormScreen extends StatefulWidget {
  final String breedName;
  final double confidence;

  const RegistrationFormScreen({
    super.key,
    required this.breedName,
    required this.confidence,
  });

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Auto-filled fields
  late String _animalId;
  late String _predictedBreed;
  late double _confidence;
  late DateTime _dateTime;
  String _location = 'Requesting location permission...';
  double? _latitude;
  double? _longitude;
  
  // User input fields - Multiple vaccinations support
  List<Map<String, dynamic>> _vaccinationRecords = [];
  
  // Loading states
  bool _isLocationLoading = true;
  bool _isSaving = false;
  
  // Data service
  final AnimalDataService _dataService = AnimalDataService();
  
  // Common cattle vaccinations
  final List<String> _availableVaccinations = [
    'FMD (Foot and Mouth Disease)',
    'Brucellosis',
    'Anthrax',
    'Blackleg (Clostridial)',
    'Hemorrhagic Septicemia (HS)',
    'Rabies',
    'Lumpy Skin Disease (LSD)',
    'Bovine Viral Diarrhea (BVD)',
    'Infectious Bovine Rhinotracheitis (IBR)',
    'Theileriosis',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAutoFields();
    _getCurrentLocation();
    // Vaccination records are optional - users can add them if needed
  }

  void _initializeAutoFields() {
    // Generate UUID-like animal ID
    _animalId = 'CX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _predictedBreed = widget.breedName;
    _confidence = widget.confidence;
    _dateTime = DateTime.now();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _location = 'Requesting location permission...';
        _isLocationLoading = true;
      });

      // First check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _location = 'Location service is disabled. Please enable GPS.';
          _isLocationLoading = false;
        });
        return;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      // Request permission if denied
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      // Handle permission permanently denied
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _location = 'Location permission permanently denied. Tap to open settings.';
          _isLocationLoading = false;
        });
        _showPermissionDialog();
        return;
      }

      // Check if permission is granted
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        
        setState(() {
          _location = 'Getting GPS coordinates...';
        });

        // Get current position with timeout
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        );
        
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _location = 'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
          _isLocationLoading = false;
        });
        
        print('Location obtained: $_latitude, $_longitude'); // Debug log
        
      } else {
        setState(() {
          _location = 'Location permission denied. Tap to retry.';
          _isLocationLoading = false;
        });
      }
    } catch (e) {
      print('Location error: $e'); // Debug log
      setState(() {
        _location = 'Unable to get location. Tap to retry.';
        _isLocationLoading = false;
      });
    }
  }

  Future<void> _retryLocation() async {
    await _getCurrentLocation();
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'This app needs location permission to record GPS coordinates for animal registration. Please enable location permission in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _addVaccination() {
    setState(() {
      _vaccinationRecords.add({
        'vaccination': null,
        'date': null,
      });
    });
  }

  void _removeVaccination(int index) {
    setState(() {
      _vaccinationRecords.removeAt(index);
    });
  }

  void _updateVaccination(int index, String field, dynamic value) {
    setState(() {
      _vaccinationRecords[index][field] = value;
    });
  }


  Future<void> _saveRegistration() async {
    print('=== REGISTRATION DEBUG ===');
    print('Animal ID: $_animalId');
    print('Breed: $_predictedBreed');
    
    // Validate only completed vaccination records (if any exist)
    if (_vaccinationRecords.isNotEmpty) {
      bool allValid = true;
      for (var record in _vaccinationRecords) {
        if (record['vaccination'] == null || record['date'] == null) {
          allValid = false;
          break;
        }
      }

      if (!allValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete all vaccination records or remove incomplete ones'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      // Save to Firebase
      await _dataService.saveAnimalData(
        animalId: _animalId,
        breedName: _predictedBreed,
        confidence: _confidence,
        latitude: _latitude ?? 0.0,
        longitude: _longitude ?? 0.0,
        dateTime: _dateTime,
        vaccinations: _vaccinationRecords,
      );
      
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Animal registration saved successfully!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Navigate back to scanner with success result
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        
        // Check if this is a warning (data saved but image failed) or a real error
        bool isWarning = e.toString().contains('image upload failed') && 
                        e.toString().contains('saved successfully');
        
        // Show appropriate message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isWarning 
                ? 'Registration saved! Note: Image upload failed - you can retry later.'
                : 'Failed to save registration: $e'
            ),
            backgroundColor: isWarning ? Colors.orange : Colors.red,
            duration: Duration(seconds: isWarning ? 4 : 3),
            action: isWarning 
                ? SnackBarAction(
                    label: 'OK',
                    textColor: Colors.white,
                    onPressed: () {
                      // Navigate back with success even if image failed
                      Navigator.of(context).pop(true);
                    },
                  )
                : null,
          ),
        );
        
        // If it's just a warning, still consider it a success
        if (isWarning) {
          // Small delay then navigate back
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          });
        }
      }
    }
  }

  Future<void> _selectDateForVaccination(int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      _updateVaccination(index, 'date', picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Registration'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen.withValues(alpha: 0.1),
                      AppColors.accentGreen.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pets, color: AppColors.primaryGreen, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register New Animal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          Text(
                            'Auto-filled information from AI analysis',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Auto-filled Section
              Text(
                'Auto-Generated Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildAutoField('Animal ID', _animalId, Icons.fingerprint),
              _buildAutoField('Predicted Breed', _predictedBreed, Icons.pets),
              _buildAutoField('Confidence', '${(_confidence * 100).toStringAsFixed(1)}%', Icons.analytics),
              _buildAutoField('Date & Time', '${_dateTime.day}/${_dateTime.month}/${_dateTime.year} ${_dateTime.hour}:${_dateTime.minute.toString().padLeft(2, '0')}', Icons.access_time),
              
              InkWell(
                onTap: _isLocationLoading ? null : _retryLocation,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.location_on, color: AppColors.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'GPS Location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (!_isLocationLoading && (_location.contains('denied') || _location.contains('Unable')))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Icon(Icons.refresh, size: 16, color: AppColors.primaryGreen),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            _isLocationLoading
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _location,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    _location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _location.contains('Lat:') 
                                          ? AppColors.success 
                                          : AppColors.textSecondary,
                                      fontWeight: _location.contains('Lat:') 
                                          ? FontWeight.w600 
                                          : FontWeight.normal,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // User Input Section - Multiple Vaccinations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vaccination Records',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addVaccination,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Vaccination'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Multiple Vaccination Records
              if (_vaccinationRecords.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.vaccines, size: 48, color: AppColors.textLight),
                      const SizedBox(height: 12),
                      Text(
                        'No vaccination records added',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vaccination records are optional. Click "Add Vaccination" if you want to add vaccination details.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(_vaccinationRecords.length, (index) {
                  return _buildVaccinationCard(index);
                }),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSaving
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Saving Registration...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Save Registration',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVaccinationCard(int index) {
    final record = _vaccinationRecords[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Vaccination ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _removeVaccination(index),
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Vaccination Type Dropdown
          DropdownButtonFormField<String>(
            initialValue: record['vaccination'],
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Vaccination Type',
              prefixIcon: Icon(Icons.medical_services, color: AppColors.primaryGreen),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            items: _availableVaccinations.map((vaccination) {
              return DropdownMenuItem(
                value: vaccination,
                child: Text(
                  vaccination,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (value) {
              _updateVaccination(index, 'vaccination', value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Vaccination Date
          InkWell(
            onTap: () => _selectDateForVaccination(index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      record['date'] != null
                          ? '${record['date'].day}/${record['date'].month}/${record['date'].year}'
                          : 'Select vaccination date',
                      style: TextStyle(
                        fontSize: 14,
                        color: record['date'] != null 
                            ? AppColors.textPrimary 
                            : AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoField(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
