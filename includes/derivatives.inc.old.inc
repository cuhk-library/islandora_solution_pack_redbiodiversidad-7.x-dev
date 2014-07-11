<?php

/**
 * @file
 * Functions deriving images for objects.
 */



/**
 * Adds a datastream to an object.
 *
 * @param AbstractObject $object
 *   The object to add a datastream to.
 * @param string $dsid
 *   The datastream ID to be added.
 * @param string $file
 *   The URI of the file to be added as the datastream content.
 *
 * @return bool|string
 *   TRUE if the datastream was added/modified successfully, the error message
 *   otherwise.
 */
function islandora_red_biodiversidad_add_datastream(AbstractObject $object, $dsid, $file) {
  try {
    $ingest = !isset($object[$dsid]);
    if ($ingest) {
      $ds = $object->constructDatastream($dsid, 'M');
      $ds->label = $dsid;
      $ds->mimeType = $object['OBJ']->mimeType;
    }
    else {
      $ds = $object[$dsid];
    }
    $ds->setContentFromFile(drupal_realpath($file->uri));
    if ($ingest) {
      $object->ingestDatastream($ds);
    }
    file_delete($file);
    return TRUE;
  }
  catch (exception $e) {
    $variables = array(
      '@ret' => $e->getTraceAsString(),
    );
    watchdog('islandora_red_biodiversidad', 'Red Biodiversidad failed to add data stream.<br/>Error: @ret', $variables, WATCHDOG_ERROR);
    $message = $e->getMessage();
    return $message;
  }
}


/**
 * Copies the OBJ to the file system.
 *
 * @param AbstractObject $object
 *   An AbstractObject representing an object within Fedora.
 *
 * @return array|stdClass
 *   FALSE when the object doesn't have the OBJ, an array otherwise.
 */
function islandora_red_biodiversidad_copy_obj_datastream(AbstractObject $object) {
  $mime_detect = new MimeDetect();
  if (!isset($object['OBJ'])) {
    return FALSE;
  }
  $ext = $mime_detect->getExtension($object['OBJ']->mimeType);
  $file_name = str_replace(':', '-', $object->id);

  // Create a file object we can save.
  $file_uri = file_create_filename("{$file_name}OBJ.{$ext}", 'temporary://');
  $file = new stdClass();
  $file->uri = $file_uri;
  $file->filename = $file_name;
  $file->filemime = $object['OBJ']->mimeType;
  // Temporary.
  $file->status = 0;
  $object['OBJ']->getContent($file_uri);
  $original_file = file_save($file);
  return array(
    'file' => $original_file,
    'extension' => $ext,
    'filename' => $file_name,
  );
}

/**
 * Helper function that returns a message when no OBJ datastream exists.
 *
 * @param string $pid
 *   The PID of the object that derivatives are being generated on.
 *
 * @return array
 *   An array describing the failure of the operation.
 *
 * @see hook_islandora_derivative()
 */
function islandora_red_biodiversidad_no_obj_datastream($pid) {
  return array(
    'success' => FALSE,
    'messages' => array(
      array(
        'message' => t('Could not create image derivatives for %s. No image file was uploaded.'),
        'message_sub' => array('%s' => $pid),
        'type' => 'watchdog',
        'severity' => WATCHDOG_ERROR,
      ),
    ),
  );
}

/**
 * Helper function that returns a message when the image fails to scale.
 *
 * @return array
 *   An array describing the failure of the operation.
 *
 * @see hook_islandora_derivative()
 */
function islandora_red_biodiversidad_failed_scaling() {
  return array(
    'success' => FALSE,
    'messages' => array(
      array(
        'message' => t('Unable to scale the image, the datastream was not added'),
        'type' => 'dsm',
        'severity' => 'warning',
      ),
    ),
  );
}

/**
 * Helper function describing failure when adding/modifying a datastream.
 *
 * @param string $message
 *   The error message returned when attempting to add/modify.
 *
 * @return array
 *   An array describing the failure of the operation.
 *
 * @see hook_islandora_derivative()
 */
function islandora_red_biodiversidad_failed_adding($message) {
  return array(
    'success' => FALSE,
    'messages' => array(
      array(
        'message' => $message,
        'type' => 'watchdog',
        'severity' => WATCHDOG_ERROR,
      ),
    ),
  );
}